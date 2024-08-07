from langchain_community.chat_models import ChatMaritalk
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts.chat import ChatPromptTemplate

chave_api_maritaca = r.chave_api_maritaca

maritaca = ChatMaritalk(
    model = "sabia-2-small", 
    api_key = chave_api_maritaca,
    temperature = 0.1,
    max_tokens = 2000,
)

nome_indice = "rag-ggplot"
embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
base_conhecimento = PineconeVectorStore.from_existing_index(
    index_name = nome_indice,
    embedding = embeddings
)

qa = RetrievalQA.from_chain_type(  
    llm = maritaca,  
    chain_type = "stuff",  
    retriever = base_conhecimento.as_retriever()  
)

pergunta = "Como fazer grafico de linha no ggplot?"
qa.run(pergunta)
