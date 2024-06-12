from fastapi import FastAPI
from pydantic import BaseModel
from PIL import Image
import io

app = FastAPI()

class AccidentDescription(BaseModel):
    party_one_description: str
    party_two_description: str

@app.post("/assess_fault")
async def assess_fault(descriptions: AccidentDescription):
    print(descriptions)
    # Load a predefined image
    with open("data/imgs/67.jpeg", "rb") as image_file:
        image = Image.open(io.BytesIO(image_file.read()))

    # Here, call your custom GPT model to get the fault assessment and justification
    # For demonstration, let's use a placeholder response
    fault_assessment = {
        "party_one_fault": 60,
        "party_two_fault": 40,
        "justification": "Based on the descriptions and the photo evidence, party one is more at fault."
    }

    return fault_assessment

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
