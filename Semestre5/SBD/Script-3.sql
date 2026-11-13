
USE nexumvitae;

-- As vistas dependem de Pessoa e de AtoMedico, por isso saem primeiro.
DROP VIEW IF EXISTS vAtoMedico;
DROP VIEW IF EXISTS vPessoa;

-- Associações M:N do Utente (referenciam Utente e os catálogos).
DROP TABLE IF EXISTS Reagir;
DROP TABLE IF EXISTS Herdar;
DROP TABLE IF EXISTS Padecer;
DROP TABLE IF EXISTS Planear;

-- Tudo o que depende de AtoMedico: associações M:N e entidades fracas.
-- Anexo sai antes de Requisicao, de que é entidade fraca.
DROP TABLE IF EXISTS Administrar;
DROP TABLE IF EXISTS Executar;
DROP TABLE IF EXISTS Diagnosticar;
DROP TABLE IF EXISTS Anexo;
DROP TABLE IF EXISTS Requisicao;
DROP TABLE IF EXISTS Medicamento;

-- AtoMedico referencia Utente, Clinica, TipoCuidado e Profissional.
DROP TABLE IF EXISTS AtoMedico;

-- Organização das clínicas. Turno sai antes de Vincular (chave estrangeira
-- composta) e Disponibilizar antes de Horario.
DROP TABLE IF EXISTS Envolver;
DROP TABLE IF EXISTS Disponibilizar;
DROP TABLE IF EXISTS Turno;
DROP TABLE IF EXISTS Vincular;
DROP TABLE IF EXISTS Horario;
DROP TABLE IF EXISTS Clinica;

-- Profissional referencia Categoria e Especialidade, por isso sai antes delas.
DROP TABLE IF EXISTS Atuar;
DROP TABLE IF EXISTS Profissional;

-- Tabelas de catálogo: já nenhuma tabela as referencia.
DROP TABLE IF EXISTS Vacina;
DROP TABLE IF EXISTS Procedimento;
DROP TABLE IF EXISTS Alergenio;
DROP TABLE IF EXISTS Patologia;
DROP TABLE IF EXISTS TipoCuidado;
DROP TABLE IF EXISTS Especialidade;
DROP TABLE IF EXISTS Categoria;

-- Por fim, a generalização: atributos multivalor, subentidade e Pessoa.
DROP TABLE IF EXISTS UtenteAnteCirurgico;
DROP TABLE IF EXISTS UtentePrefLingCulturais;
DROP TABLE IF EXISTS Utente;
DROP TABLE IF EXISTS PessoaEmail;
DROP TABLE IF EXISTS PessoaTelefone;
DROP TABLE IF EXISTS Pessoa;

-- Com as tabelas já removidas, elimina-se a própria base de dados.
DROP DATABASE IF EXISTS nexumvitae;