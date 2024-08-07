# ---- exemplo embedding ----
import os
from langchain_pinecone import PineconeVectorStore
from langchain_openai import OpenAIEmbeddings
from pinecone.grpc import PineconeGRPC as Pinecone
from pinecone import ServerlessSpec

os.environ["OPENAI_API_KEY"] = r.chave_api_openai
os.environ['PINECONE_API_KEY'] = r.chave_api_pinecone

embeddings = OpenAIEmbeddings(model = "text-embedding-ada-002")

# criando um vetor de embedding com o conteudo da centesima parte
resultado = embeddings.embed_query(partes_pdf[100].page_content)
print(partes_pdf[100].page_content)
print(resultado)

# ---- criar indice (index) no pinecone
pc = Pinecone(os.environ['PINECONE_API_KEY'])

nome_indice = "rag-ggplot"

if nome_indice not in pc.list_indexes().names():
    pc.create_index(
        name = nome_indice,
        dimension = 1536,
        metric = "cosine",
        spec = ServerlessSpec(
            cloud = 'aws', 
            region = 'us-east-1'
        ) 
    ) 

# ---- subir vetores no pinecone ----
vectorstore_from_docs = PineconeVectorStore.from_documents(
    partes_pdf,
    index_name = nome_indice,
    embedding = embeddings
)

# ---- carregar os vetores armazenados no pinecone ----
base_conhecimento = PineconeVectorStore.from_existing_index(
    index_name = nome_indice,
    embedding = embeddings
)

# ---- testar busca por similaridade ----

pergunta = "Como rotacionar o texto no eixo x de um gráfico ggplot?"
resultado = base_conhecimento.similarity_search(pergunta, k = 3)
print(resultado[0])
print(resultado[1])
print(resultado[2])
