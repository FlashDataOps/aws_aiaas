from langchain_aws import ChatBedrock

def main(query: str)->str:

    # Use Titan model from Bedrock
    llm = ChatBedrock(
        model_id="amazon.titan-tg1-large",  # Choose Titan model
        model_kwargs=dict(temperature=0.7),
    )

    messages = [
        ("system", "You are a helpful assistant. Please assist the user."),
        ("human", query),
    ]
    ai_msg = llm.invoke(messages)

    return ai_msg.content

if __name__ == '__main__':
    query = 'what is the most popular male name in spain?'
    response = main(query)
    print(response)