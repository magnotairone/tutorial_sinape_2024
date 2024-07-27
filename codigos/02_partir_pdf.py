# ---- partir o pdf em pedacos (chunks) ----
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader

loader = PyPDFLoader('codigos/docs/ggplot2.pdf')

paginas = loader.load()
print(type(paginas)) 
print(len(paginas))

tamanho_pedaco = 4000
tamanho_intersecao = 150

divisor_documentos = CharacterTextSplitter(
  chunk_size = tamanho_pedaco, 
  chunk_overlap = tamanho_intersecao, 
  separator = " "
)
partes_pdf = divisor_documentos.split_documents(paginas)

print(len(partes_pdf))
partes_pdf


