# Rubi nos Trilhos - Desafio 2: Upload em Massa de Dados (Admin)
## ✨ Descrição
Este projeto implementa uma funcionalidade para upload e processamento de arquivos de texto, permitindo que administradores enviem dados em massa para criação de usuários, empresas e vagas de emprego. O processamento é realizado de forma assíncrona utilizando Solid Queue, garantindo escalabilidade e performance. O progresso do processamento é acompanhado em tempo real através de TurboStream e Redis, proporcionando atualizações instantâneas na interface.

## 🔧 Funcionalidades Principais
🗂 1. Interface de Upload de Arquivo
Desenvolvida uma tela para o administrador selecionar e enviar um arquivo de texto para processamento.

Incluído um botão de envio e uma área de feedback para exibir o status do processamento.

⚡ 2. Processamento Assíncrono com Solid Queue
Implementado processamento assíncrono de cada linha do arquivo para garantir escalabilidade e eficiência.

Utilizado Solid Queue para gerenciar a execução dos jobs.

Cada linha do arquivo é identificada pelo primeiro caractere (U, E ou V), que define a ação a ser realizada:

U: Criar um usuário.

E: Criar uma empresa.

V: Criar uma vaga de emprego vinculada a uma empresa.

Tratamento de erros implementado para garantir a continuidade do processamento em caso de dados inválidos.

🔄 3. Acompanhamento de Progresso em Tempo Real
Integrado TurboStream e Redis para atualizações dinâmicas da interface em tempo real.

Exibição das seguintes informações durante o processamento:

Número de linhas processadas.

Número de linhas restantes.

Registros criados com sucesso.

Linhas com erros.

🛠️ 4. Tratamento de Erros e Feedback
Erros são registrados sem interromper o processamento do arquivo.

Ao final do processamento, o administrador recebe uma lista de erros detalhada, contendo:

Número da linha.

Tipo do erro.

Dados da linha problemática.

Opção para baixar um relatório de erros em formato detalhado.

✅ 5. Notificação de Conclusão
Após o processamento, o administrador recebe uma mensagem de sucesso com o total de registros criados.

Se houver erros, um botão para baixar o relatório de erros é exibido.

Resumo final indicando quantos usuários, empresas e vagas foram criados com sucesso.

## 🧰 Tecnologias Utilizadas
Ruby on Rails: Framework backend para processamento de dados e gerenciamento de jobs.

Solid Queue: Para processamento assíncrono e gerenciamento de filas de jobs.

TurboStream: Para atualizações em tempo real na interface.

Redis: Para comunicação em tempo real e suporte ao TurboStream.

## 🚀 Pontos de Melhoria
Ampliar cobertura de testes: Adicionar mais cenários de teste para garantir robustez.

Refinar tratamento de erros: Melhorar mensagens de erro e logs para facilitar a depuração.

Melhorar layout: Aprimorar a interface para uma experiência mais intuitiva.

Otimizar fluidez da funcionalidade: Garantir que o processo de upload e processamento seja suave e eficiente.