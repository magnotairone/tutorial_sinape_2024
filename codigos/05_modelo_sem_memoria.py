# --- teste inicial: chat sem contexto ---
from langchain.chains import RetrievalQA  
from langchain_openai import ChatOpenAI  
from langchain_openai import OpenAIEmbeddings
from langchain_pinecone import PineconeVectorStore

llm = ChatOpenAI(  
    openai_api_key = os.environ["OPENAI_API_KEY"],  
    model_name = "gpt-4o-mini",  
    temperature = 0.0  
)  

nome_indice = "tutorial-sinape"
embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
base_conhecimento = PineconeVectorStore.from_existing_index(
    index_name = nome_indice,
    embedding = embeddings
)

qa = RetrievalQA.from_chain_type(  
    llm = llm,  
    chain_type = "stuff",  
    retriever = base_conhecimento.as_retriever()  
)

pergunta = "Como fazer grafico de linha no ggplot?"
qa.invoke(pergunta) 
