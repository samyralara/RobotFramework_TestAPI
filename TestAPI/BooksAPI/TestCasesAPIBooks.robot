***Settings***

Resource        ResourceAPI.robot


Suite Setup     Conectar a API


***Test Cases***

Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir status code      200
    Conferir o reason       OK
    Conferir se retorna uma lista com "200" livros

Buscar um livro específico (GET em um livro específico)
    Requisitar o livro "15"
    Conferir status code      200
    Conferir o reason       OK
    Conferir se retorna todos os dados corretos do livro 15

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir se retorna todos os dados cadastrados do livro "500"

Alterar um livro (PUT)
    Alterar o livro "100"
    Conferir status code    200
    Conferir o reason   OK
    Conferir se retorna todos os dados alterados do livro "100"


Deletar um livro (DELETE)
    Excluir o livro "500"
    Conferir status code   200
    Conferir o reason   OK
#   (o response body deve ser vazio)
    Conferir se excluiu o livro "500"