
--  3.1 Script SQL DDL para criação do modelo físico 

CREATE DATABASE IF NOT EXISTS clinica CHARACTER SET utf8mb4;
USE clinica;
SELECT DATABASE();


CREATE USER IF NOT EXISTS 'clinica'@'localhost' IDENTIFIED BY 'Senha_Forte!';
GRANT ALL PRIVILEGES ON nexumvitae.* TO 'clinica'@'localhost';

DROP TABLE IF EXISTS Reagir;
DROP TABLE IF EXISTS Herdar;
DROP TABLE IF EXISTS Padecer;
DROP TABLE IF EXISTS Planear;
DROP TABLE IF EXISTS Administrar;
DROP TABLE IF EXISTS Executar;
DROP TABLE IF EXISTS Diagnosticar;
DROP TABLE IF EXISTS Anexo;
DROP TABLE IF EXISTS Requisicao;
DROP TABLE IF EXISTS Medicamento;
DROP TABLE IF EXISTS AtoMedico;
DROP TABLE IF EXISTS Atuar;
DROP TABLE IF EXISTS Envolver;
DROP TABLE IF EXISTS Disponibilizar;
DROP TABLE IF EXISTS Turno;
DROP TABLE IF EXISTS Vincular;
DROP TABLE IF EXISTS Horario;
DROP TABLE IF EXISTS Clinica;
DROP TABLE IF EXISTS Profissional;
DROP TABLE IF EXISTS Alergenio;
DROP TABLE IF EXISTS Vacina;
DROP TABLE IF EXISTS Procedimento;
DROP TABLE IF EXISTS Patologia;
DROP TABLE IF EXISTS TipoCuidado;
DROP TABLE IF EXISTS Especialidade;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS AnteCirurgico;
DROP TABLE IF EXISTS PrefLingCultural;
DROP TABLE IF EXISTS Utente;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS Telefone;
DROP TABLE IF EXISTS Pessoa;


-- A idade é derivada, por isso não é guardada.
CREATE TABLE Pessoa (
    NIF CHAR(9) NOT NULL,
    nomeCompleto VARCHAR(100) NOT NULL,
    dataNascimento DATE NOT NULL,
    genero VARCHAR(5) NOT NULL,
    morada VARCHAR(150),
    pais VARCHAR(50) NOT NULL DEFAULT 'Portugal',
    distrito VARCHAR(50),
    concelho VARCHAR(50),
    freguesia VARCHAR(50),
    CONSTRAINT pk_Pessoa PRIMARY KEY (NIF),
    CONSTRAINT ck_Pessoa_genero CHECK (genero IN ('M', 'F', 'Outro')),
    CONSTRAINT ck_Pessoa_dataNascimento CHECK (dataNascimento >= '1900-01-01'),
    -- RIA1: em Portugal, distrito, concelho e freguesia são obrigatórios;
    --       noutros países ficam vazios
    CONSTRAINT ck_Pessoa_RIA1 CHECK (
        (pais = 'Portugal' AND distrito IS NOT NULL AND concelho IS NOT NULL AND freguesia IS NOT NULL)
        OR (pais <> 'Portugal' AND distrito IS NULL AND concelho IS NULL AND freguesia IS NULL)
    )
);

-- Telefone: atributo multivalor de Pessoa.
-- Se a pessoa for apagada, os telefones também são (ON DELETE CASCADE).
CREATE TABLE Telefone (
    NIF CHAR(9) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    CONSTRAINT pk_Telefone PRIMARY KEY (NIF, telefone),
    CONSTRAINT fk_Telefone_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Email: atributo multivalor de Pessoa.
CREATE TABLE Email (
    NIF CHAR(9) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT pk_Email PRIMARY KEY (NIF, email),
    CONSTRAINT fk_Email_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Utente: subentidade de Pessoa (a chave primária é também chave estrangeira).
CREATE TABLE Utente (
    NIF CHAR(9) NOT NULL,
    numSNS CHAR(9) NOT NULL,
    grupoSanguineo VARCHAR(3),
    nomeContactoEmerg VARCHAR(100),
    parentContactoEmerg VARCHAR(30),
    telContactoEmerg VARCHAR(20),
    estiloVida VARCHAR(500),
    CONSTRAINT pk_Utente PRIMARY KEY (NIF),
    CONSTRAINT ak_Utente_numSNS UNIQUE (numSNS),
    CONSTRAINT ck_Utente_grupoSanguineo CHECK (grupoSanguineo IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    CONSTRAINT fk_Utente_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- PrefLingCultural: atributo multivalor de Utente.
CREATE TABLE PrefLingCultural (
    NIF CHAR(9) NOT NULL,
    prefLingCultural VARCHAR(100) NOT NULL,
    CONSTRAINT pk_PrefLingCultural PRIMARY KEY (NIF, prefLingCultural),
    CONSTRAINT fk_PrefLingCultural_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- AnteCirurgico: atributo multivalor de Utente.
CREATE TABLE AnteCirurgico (
    NIF CHAR(9) NOT NULL,
    anteCirurgico VARCHAR(500) NOT NULL,
    CONSTRAINT pk_AnteCirurgico PRIMARY KEY (NIF, anteCirurgico),
    CONSTRAINT fk_AnteCirurgico_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Categoria (
    codCategoria INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Categoria PRIMARY KEY (codCategoria),
    CONSTRAINT ak_Categoria_designacao UNIQUE (designacao),
    CONSTRAINT ck_Categoria_designacao CHECK (designacao IN ('Médico', 'Enfermeiro',
        'Técnico Superior de Diagnóstico e Terapêutica', 'Fisioterapeuta',
        'Psicólogo', 'Auxiliar de Ação Médica'))
);

CREATE TABLE Especialidade (
    codEspecialidade INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(100) NOT NULL,
    CONSTRAINT pk_Especialidade PRIMARY KEY (codEspecialidade),
    CONSTRAINT ak_Especialidade_designacao UNIQUE (designacao)
);

CREATE TABLE TipoCuidado (
    codTipoCuidado INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(100) NOT NULL,
    CONSTRAINT pk_TipoCuidado PRIMARY KEY (codTipoCuidado),
    CONSTRAINT ak_TipoCuidado_designacao UNIQUE (designacao),
    CONSTRAINT ck_TipoCuidado_designacao CHECK (designacao IN (
        'Consultas Médicas de Especialidade',
        'Exames Complementares de Diagnóstico',
        'Intervenções Cirúrgicas e Bloco Ambulatório',
        'Medicina Preventiva e Promoção da Saúde',
        'Tratamentos Terapêuticos e Atos de Enfermagem',
        'Reabilitação e Fisioterapia',
        'Saúde Mental e Acompanhamento Psicológico'))
);

-- Patologia: o código é o código ICD-11 (ex.: '5A11'), por isso não é AUTO_INCREMENT
CREATE TABLE Patologia (
    codICD11 VARCHAR(10) NOT NULL,
    designacao VARCHAR(150) NOT NULL,
    CONSTRAINT pk_Patologia PRIMARY KEY (codICD11),
    CONSTRAINT ak_Patologia_designacao UNIQUE (designacao)
);

CREATE TABLE Procedimento (
    codProcedimento INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(150) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT pk_Procedimento PRIMARY KEY (codProcedimento),
    CONSTRAINT ak_Procedimento_designacao UNIQUE (designacao),
    CONSTRAINT ck_Procedimento_tipo CHECK (tipo IN ('cirurgia', 'tratamento', 'ato de enfermagem'))
);

CREATE TABLE Vacina (
    codVacina INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    CONSTRAINT pk_Vacina PRIMARY KEY (codVacina)
);

CREATE TABLE Alergenio (
    codAlergenio INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(100) NOT NULL,
    tipo VARCHAR(15) NOT NULL,
    CONSTRAINT pk_Alergenio PRIMARY KEY (codAlergenio),
    CONSTRAINT ak_Alergenio_designacao UNIQUE (designacao),
    CONSTRAINT ck_Alergenio_tipo CHECK (tipo IN ('medicamentoso', 'alimentar', 'ambiental'))
);

-- Profissional: subentidade de Pessoa.
--   codCategoria     - associação pertencer (obrigatória)
--   codEspecialidade - associação especializar (especialidade principal, pode ser nula)
CREATE TABLE Profissional (
    NIF CHAR(9) NOT NULL,
    numProfissional INT NOT NULL,
    numDocIdentificacao VARCHAR(20) NOT NULL,
    nomeClinico VARCHAR(50) NOT NULL,
    fotografia VARCHAR(255),
    estado VARCHAR(10) NOT NULL DEFAULT 'Ativo',
    codCategoria INT NOT NULL,
    codEspecialidade INT,
    CONSTRAINT pk_Profissional PRIMARY KEY (NIF),
    CONSTRAINT ak_Profissional_numProfissional UNIQUE (numProfissional),
    CONSTRAINT ak_Profissional_numDocIdentificacao UNIQUE (numDocIdentificacao),
    CONSTRAINT ck_Profissional_numProfissional CHECK (numProfissional > 0),
    CONSTRAINT ck_Profissional_estado CHECK (estado IN ('Ativo', 'Inativo', 'Licença')),
    CONSTRAINT fk_Profissional_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Profissional_Categoria FOREIGN KEY (codCategoria)
        REFERENCES Categoria (codCategoria)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_Profissional_Especialidade FOREIGN KEY (codEspecialidade)
        REFERENCES Especialidade (codEspecialidade)
        ON DELETE NO ACTION ON UPDATE CASCADE
);




CREATE TABLE Clinica (
    localidade VARCHAR(50) NOT NULL,
    morada VARCHAR(150) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT pk_Clinica PRIMARY KEY (localidade),
    CONSTRAINT ak_Clinica_coordenadas UNIQUE (latitude, longitude),
    CONSTRAINT ck_Clinica_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_Clinica_longitude CHECK (longitude BETWEEN -180 AND 180)
);

-- Horario: entidade fraca de Clinica (chave = localidade + diaSemana).
CREATE TABLE Horario (
    localidade VARCHAR(50) NOT NULL,
    diaSemana VARCHAR(7) NOT NULL,
    horaAbertura TIME NOT NULL,
    horaFecho TIME NOT NULL,
    CONSTRAINT pk_Horario PRIMARY KEY (localidade, diaSemana),
    CONSTRAINT ck_Horario_diaSemana CHECK (diaSemana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta')),
    CONSTRAINT ck_Horario_RIA6 CHECK (horaAbertura < horaFecho),
    CONSTRAINT fk_Horario_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Vincular: entidade associativa Profissional - Clinica (M:N).
CREATE TABLE Vincular (
    NIF CHAR(9) NOT NULL,
    localidade VARCHAR(50) NOT NULL,
    tipoVinculo VARCHAR(25) NOT NULL,
    CONSTRAINT pk_Vincular PRIMARY KEY (NIF, localidade),
    CONSTRAINT ck_Vincular_tipoVinculo CHECK (tipoVinculo IN ('contrato de trabalho', 'prestação de serviços', 'avença')),
    CONSTRAINT fk_Vincular_Profissional FOREIGN KEY (NIF)
        REFERENCES Profissional (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Vincular_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Turno: entidade fraca de Vincular.
-- A chave estrangeira composta garante que só há turnos onde existe vínculo.
CREATE TABLE Turno (
    NIF CHAR(9) NOT NULL,
    localidade VARCHAR(50) NOT NULL,
    diaSemana VARCHAR(7) NOT NULL,
    horaInicio TIME NOT NULL,
    horaFim TIME NOT NULL,
    CONSTRAINT pk_Turno PRIMARY KEY (NIF, localidade, diaSemana, horaInicio),
    CONSTRAINT ck_Turno_diaSemana CHECK (diaSemana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta')),
    CONSTRAINT ck_Turno_RIA6 CHECK (horaInicio < horaFim),
    CONSTRAINT fk_Turno_Vincular FOREIGN KEY (NIF, localidade)
        REFERENCES Vincular (NIF, localidade)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Disponibilizar: M:N Horario - TipoCuidado.
CREATE TABLE Disponibilizar (
    localidade VARCHAR(50) NOT NULL,
    diaSemana VARCHAR(7) NOT NULL,
    codTipoCuidado INT NOT NULL,
    CONSTRAINT pk_Disponibilizar PRIMARY KEY (localidade, diaSemana, codTipoCuidado),
    CONSTRAINT fk_Disponibilizar_Horario FOREIGN KEY (localidade, diaSemana)
        REFERENCES Horario (localidade, diaSemana)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Disponibilizar_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Envolver: M:N TipoCuidado - Categoria.
CREATE TABLE Envolver (
    codTipoCuidado INT NOT NULL,
    codCategoria INT NOT NULL,
    CONSTRAINT pk_Envolver PRIMARY KEY (codTipoCuidado, codCategoria),
    CONSTRAINT fk_Envolver_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Envolver_Categoria FOREIGN KEY (codCategoria)
        REFERENCES Categoria (codCategoria)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Atuar: M:N Profissional - Especialidade (áreas de atuação).
CREATE TABLE Atuar (
    NIF CHAR(9) NOT NULL,
    codEspecialidade INT NOT NULL,
    CONSTRAINT pk_Atuar PRIMARY KEY (NIF, codEspecialidade),
    CONSTRAINT fk_Atuar_Profissional FOREIGN KEY (NIF)
        REFERENCES Profissional (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Atuar_Especialidade FOREIGN KEY (codEspecialidade)
        REFERENCES Especialidade (codEspecialidade)
        ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE AtoMedico (
    numAto INT NOT NULL AUTO_INCREMENT,
    dataHoraAgenda DATETIME NOT NULL,
    dataHoraAtend DATETIME,
    estado VARCHAR(10) NOT NULL DEFAULT 'agendado',
    motivo VARCHAR(200),
    anamnese VARCHAR(1000),
    pressaoArterial VARCHAR(7),
    freqCardiaca INT,
    temperatura DECIMAL(3, 1),
    peso DECIMAL(5, 2),
    altura DECIMAL(3, 2),
    notasClinicas VARCHAR(2000),
    planoTerapeutico VARCHAR(1000),
    avaliacao VARCHAR(20),
    comentario VARCHAR(500),
    NIFUtente CHAR(9) NOT NULL,
    localidade VARCHAR(50) NOT NULL,
    codTipoCuidado INT NOT NULL,
    NIFPreferido CHAR(9),
    NIFResponsavel CHAR(9),
    CONSTRAINT pk_AtoMedico PRIMARY KEY (numAto),
    CONSTRAINT ck_AtoMedico_estado CHECK (estado IN ('agendado', 'realizado', 'cancelado', 'adiado')),
    CONSTRAINT ck_AtoMedico_avaliacao CHECK (avaliacao IN ('adorei', 'gostei', 'não pretendo voltar')),
    CONSTRAINT ck_AtoMedico_freqCardiaca CHECK (freqCardiaca > 0),
    CONSTRAINT ck_AtoMedico_temperatura CHECK (temperatura BETWEEN 30 AND 45),
    CONSTRAINT ck_AtoMedico_peso CHECK (peso > 0),
    CONSTRAINT ck_AtoMedico_altura CHECK (altura > 0),
    -- RIA13: o utente não pode ser o responsável pelo próprio ato
    CONSTRAINT ck_AtoMedico_RIA13 CHECK (NIFResponsavel <> NIFUtente),
    -- RIA15: um ato realizado tem responsável e dataHoraAtend >= dataHoraAgenda
    CONSTRAINT ck_AtoMedico_RIA15 CHECK (estado <> 'realizado'
        OR (NIFResponsavel IS NOT NULL AND dataHoraAtend >= dataHoraAgenda)),
    -- RIA17: avaliação e comentário só em atos realizados
    CONSTRAINT ck_AtoMedico_RIA17 CHECK (estado = 'realizado'
        OR (avaliacao IS NULL AND comentario IS NULL)),
    CONSTRAINT fk_AtoMedico_Utente FOREIGN KEY (NIFUtente)
        REFERENCES Utente (NIF),
    CONSTRAINT fk_AtoMedico_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_AtoMedico_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_AtoMedico_Preferido FOREIGN KEY (NIFPreferido)
        REFERENCES Profissional (NIF)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_AtoMedico_Responsavel FOREIGN KEY (NIFResponsavel)
        REFERENCES Profissional (NIF)
);

-- Medicamento: entidade fraca de AtoMedico.
CREATE TABLE Medicamento (
    numAto INT NOT NULL,
    codMedicamento INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    dosagem VARCHAR(50),
    posologia VARCHAR(100),
    durTratamento INT,
    CONSTRAINT pk_Medicamento PRIMARY KEY (numAto, codMedicamento),
    CONSTRAINT ck_Medicamento_codMedicamento CHECK (codMedicamento > 0),
    CONSTRAINT ck_Medicamento_durTratamento CHECK (durTratamento > 0),
    CONSTRAINT fk_Medicamento_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Requisicao: entidade fraca de AtoMedico.
CREATE TABLE Requisicao (
    numAto INT NOT NULL,
    numRequisicao INT NOT NULL,
    tipoExame VARCHAR(100) NOT NULL,
    data DATE NOT NULL DEFAULT (CURRENT_DATE),
    estado VARCHAR(10) NOT NULL DEFAULT 'pendente',
    resultado VARCHAR(1000),
    CONSTRAINT pk_Requisicao PRIMARY KEY (numAto, numRequisicao),
    CONSTRAINT ck_Requisicao_numRequisicao CHECK (numRequisicao > 0),
    CONSTRAINT ck_Requisicao_estado CHECK (estado IN ('pendente', 'realizada')),
    -- RIA19: só requisições realizadas têm resultado
    CONSTRAINT ck_Requisicao_RIA19 CHECK (estado = 'realizada' OR resultado IS NULL),
    CONSTRAINT fk_Requisicao_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Anexo: entidade fraca de Requisicao (guarda o caminho do ficheiro).
CREATE TABLE Anexo (
    numAto INT NOT NULL,
    numRequisicao INT NOT NULL,
    numAnexo INT NOT NULL,
    nomeFicheiro VARCHAR(100) NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    ficheiro VARCHAR(255) NOT NULL,
    dataUpload DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    CONSTRAINT pk_Anexo PRIMARY KEY (numAto, numRequisicao, numAnexo),
    CONSTRAINT ck_Anexo_numAnexo CHECK (numAnexo > 0),
    CONSTRAINT ck_Anexo_tipo CHECK (tipo IN ('relatório', 'imagem', 'outro')),
    CONSTRAINT fk_Anexo_Requisicao FOREIGN KEY (numAto, numRequisicao)
        REFERENCES Requisicao (numAto, numRequisicao)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Diagnosticar: M:N AtoMedico - Patologia.
CREATE TABLE Diagnosticar (
    numAto INT NOT NULL,
    codICD11 VARCHAR(10) NOT NULL,
    CONSTRAINT pk_Diagnosticar PRIMARY KEY (numAto, codICD11),
    CONSTRAINT fk_Diagnosticar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Diagnosticar_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Executar: M:N AtoMedico - Procedimento.
CREATE TABLE Executar (
    numAto INT NOT NULL,
    codProcedimento INT NOT NULL,
    CONSTRAINT pk_Executar PRIMARY KEY (numAto, codProcedimento),
    CONSTRAINT fk_Executar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Executar_Procedimento FOREIGN KEY (codProcedimento)
        REFERENCES Procedimento (codProcedimento)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Administrar: M:N AtoMedico - Vacina (com número da dose e lote).
CREATE TABLE Administrar (
    numAto INT NOT NULL,
    codVacina INT NOT NULL,
    numDose INT NOT NULL,
    lote VARCHAR(20) NOT NULL,
    CONSTRAINT pk_Administrar PRIMARY KEY (numAto, codVacina),
    CONSTRAINT ck_Administrar_numDose CHECK (numDose > 0),
    CONSTRAINT fk_Administrar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Administrar_Vacina FOREIGN KEY (codVacina)
        REFERENCES Vacina (codVacina)
        ON DELETE NO ACTION ON UPDATE CASCADE
);



-- Planear: plano de vacinação (M:N Utente - Vacina).
CREATE TABLE Planear (
    NIF CHAR(9) NOT NULL,
    codVacina INT NOT NULL,
    dataPrevista DATE NOT NULL,
    CONSTRAINT pk_Planear PRIMARY KEY (NIF, codVacina),
    CONSTRAINT fk_Planear_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Planear_Vacina FOREIGN KEY (codVacina)
        REFERENCES Vacina (codVacina)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Padecer: doenças crónicas do utente (M:N Utente - Patologia).
CREATE TABLE Padecer (
    NIF CHAR(9) NOT NULL,
    codICD11 VARCHAR(10) NOT NULL,
    CONSTRAINT pk_Padecer PRIMARY KEY (NIF, codICD11),
    CONSTRAINT fk_Padecer_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Padecer_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Herdar: antecedentes familiares (M:N Utente - Patologia, com grau de parentesco).
CREATE TABLE Herdar (
    NIF CHAR(9) NOT NULL,
    codICD11 VARCHAR(10) NOT NULL,
    grauParent VARCHAR(5) NOT NULL,
    CONSTRAINT pk_Herdar PRIMARY KEY (NIF, codICD11),
    -- RIA5: só família direta
    CONSTRAINT ck_Herdar_grauParent CHECK (grauParent IN ('pai', 'mãe', 'irmão', 'irmã', 'filho', 'filha')),
    CONSTRAINT fk_Herdar_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Herdar_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Reagir: alergias do utente (M:N Utente - Alergenio, com a reação).
CREATE TABLE Reagir (
    NIF CHAR(9) NOT NULL,
    codAlergenio INT NOT NULL,
    reacao VARCHAR(200),
    CONSTRAINT pk_Reagir PRIMARY KEY (NIF, codAlergenio),
    CONSTRAINT fk_Reagir_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Reagir_Alergenio FOREIGN KEY (codAlergenio)
        REFERENCES Alergenio (codAlergenio)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

SHOW TABLES;