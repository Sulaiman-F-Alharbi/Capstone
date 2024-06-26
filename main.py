from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from PIL import Image
import io
import uuid
import base64
import time
import re
import json

import cloudinary
import cloudinary.uploader
import cloudinary.api

import openai
from openai import OpenAI

import weaviate
import weaviate.util

# uvicorn main:app --reload --host 0.0.0.0 --port 8000

app = FastAPI()

IMAGEDIR = "data/temp_images/"
api_key = "My API key"

#Class to store the sended data
class AccidentDescription(BaseModel):
    party_one_description: str
    party_two_description: str
    image: str


@app.post("/assess_fault")
async def assess_fault(descriptions: AccidentDescription):
    img = base64.b64decode(descriptions.image)

    filename = f"{uuid.uuid4()}.jpg"
    #save the file
    image_path = f"{IMAGEDIR}{filename}"
    with open(f"{IMAGEDIR}{filename}", "wb") as f:
        f.write(img)

    image_url = get_url(image_path)
    print(image_url)


    # Here, call your custom GPT model to get the fault assessment and justification
    predicted_dict = get_predict(descriptions, image_url)
    print(predicted_dict['Justification'])
    fault_assessment = {
        "party_one_fault": predicted_dict['First_Party_Fault'],
        "party_two_fault": predicted_dict['Second_Party_Fault'],
        "justification": predicted_dict['Justification'],
        "image": descriptions.image,
    }

    return fault_assessment

#take an image upload it to cloudinary and return its link(URL)
def get_url(imagePath):
    cloudinary.config(
    cloud_name = 'couldName',
    api_key = 'my API key',
    api_secret = 'My secret'
    )

    response = cloudinary.uploader.upload(
    imagePath,
    quality="auto:best",  # Adjusts quality automatically to the best
    fetch_format="auto"  # Adjusts format automatically
    )

    return response['url']

#connect to our openai custom agent and get both the assessment values and justification
def get_predict(descriptions: AccidentDescription, img_url):
    api_key = "sk-proj-SbWhesihM1v6il8NTKMvT3BlbkFJQkzZnQsW2JnviBzChRvF"
    # Configuration
    Assistant_ID = "asst_SmTRNw48MnpChRfXFe05EGXm"
    client = OpenAI(api_key= api_key)

    cloudinary.config(
    cloud_name = 'couldName',
    api_key = 'my API key',
    api_secret = 'My secret'
    )
    

    #Connect to the assistant and get the predicted values
    #getting repsonse fault assessment from assistant
    thread = client.beta.threads.create(
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        #prompt
                        "text": """
                                    first_party:
                                    """+ descriptions.party_one_description + """
                                    second_party:
                                """ + descriptions.party_two_description
                    },
                        
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": img_url,
                            "detail": "high"
                        }
                    },
                ] ,           
            },
        ],
    )


    run = client.beta.threads.runs.create(
    thread_id=thread.id,
    assistant_id=Assistant_ID,
    )

    print(f" Run Created: {run.id}")

    while (run.status != "completed"):
        run = client.beta.threads.runs.retrieve(
            thread_id=thread.id,
            run_id=run.id
        )
        print("Run status: {run.status}")
        # time.sleep(1)
    else:
        print("run compleated")


    messages_response = client.beta.threads.messages.list(
        thread_id=thread.id
    )
    messages = messages_response.data
    Latest_messages = messages[0]
    response_text = Latest_messages.content[0].text.value

    #cleaning the response
    response_text = response_text.replace("```json",'').replace("```",'').replace("%", "").strip()
    cleaned_response = re.sub(r"【.*】", "", response_text)
    descrip_response = json.loads(cleaned_response)
    print(descrip_response['Justification'])
    result_dict = {
        "First_Party_Fault": descrip_response["First_Party_Fault"],
        "Second_Party_Fault": descrip_response["Second_Party_Fault"],
        "Justification": descrip_response['Justification']
    }    
    return result_dict



#function to get the similar data in the vector database (weaviate)
from fastapi import FastAPI, HTTPException

@app.post("/get_similar")
async def get_similar(descriptions: AccidentDescription):
    try:
        client = weaviate.Client("http://localhost:8080")
        client.schema.get("CarCrash")
        
        img = base64.b64decode(descriptions.image)
        filename = f"{uuid.uuid4()}.jpg"
        image_path = f"{IMAGEDIR}{filename}"
        
        with open(f"{IMAGEDIR}{filename}", "wb") as f:
            f.write(img)
        
        full_description = f'first: {descriptions.party_one_description}\nSecond: {descriptions.party_two_description}'
        print('====================================HERE===========================')
        result = test_hybrid(full_description, image_path, client)  
        print('====================================HERE2===========================')  
        
        return result[:3]
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail="An error occurred while processing the request.")


#get the similar data in the client
def test_hybrid(near_text, near_image, client):
    near_image = weaviate.util.image_encoder_b64(near_image)
    test_query = """
        {
        Get {
            Article(
            nearText: {
                concepts: ["%s"]
                fields: ["descriptions"]
            }
            nearImage: {
                image: "%s"
            }
            ) {
            descriptions
            carCrash_image
            _additional {
                certainty
            }
            }
        }
        }
        """% (near_text, near_image)

    res = client.query.get("carCrash",
                           ["carCrash_image",
                            "descriptions",
                            "firstParty_fault",
                            "secondParty_fault",
                            "justification",
                            "_additional {certainty}"]
                          ).with_hybrid(
                              query=test_query,
                              alpha=0.5
                          ).do()
    return res['data']['Get']['CarCrash']

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

