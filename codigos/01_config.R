# Sys.setenv(`OPENAI_API_KEY`= "COLE SUA CHAVE AQUI")
# Sys.setenv(`PINECONE_API_KEY`= "COLE SUA CHAVE AQUI")

reticulate::virtualenv_create(envname = "langchain_rag",
                  packages = c(
                    "langchain",
                    "langchain-community",
                    "pypdf",
                    "pinecone",
                    "langchain_pinecone",
                    "langchain-openai",
                    "pinecone-client[grpc]",
                    "langchain_openai"
                  )
)

reticulate::use_virtualenv("langchain_rag")


reticulate::py_run_string('
print("Estou em Fortaleza!") 
')

chave_api_openai <- Sys.getenv("OPENAI_API_KEY")
chave_api_pinecone <- Sys.getenv("PINECONE_API_KEY")

chave_api_maritaca <- Sys.getenv("MARITACAAI_API_KEY")

if(!(dir.exists("codigos/docs"))) {
  dir.create("codigos/docs")
}

download.file("https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf",
              destfile = "codigos/docs/ggplot2.pdf", mode = "wb")
