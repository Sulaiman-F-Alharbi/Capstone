# Final Project Proposal: Anjez Car Crash Assessment App

## Introduction
 This document serves as the proposal for my final project in the Data Science Bootcamp. The project, titled "Anjez Car Crash Assessment App", aims to address the problem of prolonged traffic congestion due to car crashes. This project is chosen due to its potential impact on the transportation industry and its alignment with my career goals in data science and AI.

## Background
The traffic in Saudi Arabia more specifically Riyadh is a parable and the number one cause for this traffic is usually car crashes, where the infected parties will block the streets even if it is a small car crash due conflicting and waiting.
This project could benefit all the people either they drive or not for these reasons:

- Saving time for the affected parties to finish their assessment as fast as possible.
- There is no need stop and block the streets for discussing who's at fault.


## Project Objectives
To solve the provided problem we will need achieve your goals which they are:
- To build a predictive model that can accurately predict the assessment fault for each party.
- To build a vector database to find the previous similar cases.
- To develop a user-friendly interface for stakeholders to interact with the findings.

## Data Sources
Describe the datasets you will use, including their sources, reliability, and any preprocessing steps you plan to take.
The type of data we needed are:
- Car crash images.
- Description of the accident from each affected party.
- The Fault assessment on each affected party.
- The traffic laws.

So we gathered car crash images many different sources and solutions:
- Kaggle.
- AI generated Photos.
- roboflow.
- Simulations.

And we got the Morro's Traffic laws in Saudi Arabia:
- اللائحة التنفيذية لنظام المرور السعودي الصادر بالقرار الوزاري رقم ٢٢٤٩ وتاريخ ١٤٤٠/٠٣/١٠ هـ.


## Methodology
Outline the methods and technologies you will use in your project. This section can include both the analytical techniques and the tools/software about the following:

- Feature Extraction: Since we don't have any car accident descriptions sources, we to the images to a LLM model from Openai to generate 4 scenarios for each image.
- Data extraction: Since we couldn't find all the data we needed like the fault assessment for each party or the parties description about the accident, we generated the description based on the collected images, where each image will have 4 scenarios:
  - First scenario: both parties telling the truth.
  - Second scenario: both parties laying.
  - Third scenario: first party is laying.
  - Fourth scenario: second party is laying.

- Feature Engineering: victorize the images and description to store it in the vector database which was Weaviate to find the similarity.

  
- **Data Cleaning and Preprocessing**:
    - Analytical techniques: We use openai Clip model to vectorize the data to use it in Weaviate.
    - Used tools: Utilizing Python libraries such as Pandas and NumPy.
- **Model Development**:
    - Analytical techniques: We deployed the idea in a flutter application where it will communicate with the LLM Openai through FastAPI where it will also connect to the Docker container of our vector database Weaviate.


## Results
By the conclusion of this project, I expect to develop a predictive LLM that predicts the fault assessment for each party and the his justification with violated laws. Additionally, getting the similar cases that are saved in the vector database.

## Conclusion
In conclusion, the Anjez Car Crash Assessment App aims to leverage data science techniques to address the problem of prolonged traffic congestion due to car crashes. This project is expected to yield significant benefits by reducing the time required for fault assessment and improving traffic flow. I am excited about the potential impacts of this project and look forward to exploring the innovative applications of AI in transportation.


## Future Improvements:
- Multi-device model deployment.
- App integration with Absher.
- Efficient car damage assessment model.

## Contact Information
Provide your contact information for further communication.

**Group Members:**
- Khalid Saeed.
- Hamad Alrashoud.
- Sulaiman Alharbi.

---
