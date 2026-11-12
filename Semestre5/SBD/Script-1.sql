CREATE DATABASE IF NOT EXISTS clinica CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE clinica;

CREATE TABLE Pessoa (
    NIF             CHAR(9)      NOT NULL,
    nomeCompleto    VARCHAR(100) NOT NULL,
    dataNascimento  DATE         NOT NULL,
    genero          VARCHAR(5)   NOT NULL,
    morada          VARCHAR(150) NOT NULL,
    pais            VARCHAR(50)  NOT NULL DEFAULT 'Portugal',
    distrito        VARCHAR(50),
    concelho        VARCHAR(50),
    freguesia       VARCHAR(50),
    CONSTRAINT pk_Pessoa PRIMARY KEY (NIF),
    CONSTRAINT ck_Pessoa_NIF CHECK (NIF REGEXP '^[0-9]{9}$'),
    CONSTRAINT ck_Pessoa_genero CHECK (genero IN ('M', 'F', 'Outro')),
    CONSTRAINT ck_Pessoa_dataNascimento CHECK (dataNascimento >= '1900-01-01'),
    CONSTRAINT ck_Pessoa_RIA1 CHECK (
        (pais = 'Portugal' AND distrito IS NOT NULL AND concelho IS NOT NULL AND freguesia IS NOT NULL)
     OR (pais <> 'Portugal' AND distrito IS NULL AND concelho IS NULL AND freguesia IS NULL))
);

CREATE TABLE PessoaTelefone (
    NIF       CHAR(9)     NOT NULL,
    telefone  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_PessoaTelefone PRIMARY KEY (NIF, telefone),
    CONSTRAINT fk_PessoaTelefone_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF) ON DELETE CASCADE
);

CREATE TABLE PessoaEmail (
    NIF    CHAR(9)      NOT NULL,
    email  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_PessoaEmail PRIMARY KEY (NIF, email),
    CONSTRAINT ck_PessoaEmail_email CHECK (email LIKE '_%@_%._%'),
    CONSTRAINT fk_PessoaEmail_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF) ON DELETE CASCADE
);

CREATE TABLE Utente (
    NIF                  CHAR(9)      NOT NULL,
    numSNS               CHAR(9)      NOT NULL,
    grupoSanguineo       VARCHAR(3)   NOT NULL,
    nomeContactoEmerg    VARCHAR(100) NOT NULL,
    parentContactoEmerg  VARCHAR(30)  NOT NULL,
    telContactoEmerg     VARCHAR(20)  NOT NULL,
    estiloVida           VARCHAR(500),
    CONSTRAINT pk_Utente PRIMARY KEY (NIF),
    CONSTRAINT ak_Utente_numSNS UNIQUE (numSNS),
    CONSTRAINT ck_Utente_numSNS CHECK (numSNS REGEXP '^[0-9]{9}$'),
    CONSTRAINT ck_Utente_grupoSanguineo CHECK (grupoSanguineo IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    CONSTRAINT fk_Utente_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF) ON DELETE RESTRICT
);

CREATE TABLE UtentePrefLingCulturais (
    NIF                CHAR(9)      NOT NULL,
    prefLingCulturais  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_UtentePrefLingCulturais PRIMARY KEY (NIF, prefLingCulturais),
    CONSTRAINT fk_UtentePrefLingCulturais_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE CASCADE
);

CREATE TABLE UtenteAnteCirurgico (
    NIF            CHAR(9)      NOT NULL,
    anteCirurgico  VARCHAR(500) NOT NULL,
    CONSTRAINT pk_UtenteAnteCirurgico PRIMARY KEY (NIF, anteCirurgico),
    CONSTRAINT fk_UtenteAnteCirurgico_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE CASCADE
);

CREATE TABLE Categoria (
    codCategoria  INT         NOT NULL AUTO_INCREMENT,
    designacao    VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Categoria PRIMARY KEY (codCategoria),
    CONSTRAINT ak_Categoria_designacao UNIQUE (designacao),
    CONSTRAINT ck_Categoria_designacao CHECK (designacao IN ('Médico', 'Enfermeiro',
        'Técnico Superior de Diagnóstico e Terapêutica', 'Fisioterapeuta',
        'Psicólogo', 'Auxiliar de Ação Médica'))
);

CREATE TABLE Especialidade (
    codEspecialidade  INT          NOT NULL AUTO_INCREMENT,
    designacao        VARCHAR(100) NOT NULL,
    CONSTRAINT pk_Especialidade PRIMARY KEY (codEspecialidade),
    CONSTRAINT ak_Especialidade_designacao UNIQUE (designacao)
);

CREATE TABLE TipoCuidado (
    codTipoCuidado  INT          NOT NULL AUTO_INCREMENT,
    designacao      VARCHAR(100) NOT NULL,
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

CREATE TABLE Patologia (
    codICD11    VARCHAR(10)  NOT NULL,
    designacao  VARCHAR(150) NOT NULL,
    CONSTRAINT pk_Patologia PRIMARY KEY (codICD11),
    CONSTRAINT ak_Patologia_designacao UNIQUE (designacao)
);

CREATE TABLE Alergenio (
    codAlergenio  INT          NOT NULL AUTO_INCREMENT,
    designacao    VARCHAR(100) NOT NULL,
    tipo          VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_Alergenio PRIMARY KEY (codAlergenio),
    CONSTRAINT ak_Alergenio_designacao UNIQUE (designacao),
    CONSTRAINT ck_Alergenio_tipo CHECK (tipo IN ('medicamentoso', 'alimentar', 'ambiental'))
);

CREATE TABLE Procedimento (
    codProcedimento  INT          NOT NULL AUTO_INCREMENT,
    designacao       VARCHAR(150) NOT NULL,
    tipo             VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_Procedimento PRIMARY KEY (codProcedimento),
    CONSTRAINT ak_Procedimento_designacao UNIQUE (designacao),
    CONSTRAINT ck_Procedimento_tipo CHECK (tipo IN ('cirurgia', 'tratamento', 'ato de enfermagem'))
);

CREATE TABLE Vacina (
    codVacina  INT          NOT NULL AUTO_INCREMENT,
    nome       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_Vacina PRIMARY KEY (codVacina)
);

CREATE TABLE Profissional (
    NIF                  CHAR(9)      NOT NULL,
    nomeClinico          VARCHAR(50)  NOT NULL,
    numDocIdentificacao  VARCHAR(20)  NOT NULL,
    fotografia           VARCHAR(255),
    numProfissional      INT          NOT NULL,
    estado               VARCHAR(10)  NOT NULL DEFAULT 'Ativo',
    codCategoria         INT          NOT NULL,
    codEspecialidade     INT,
    CONSTRAINT pk_Profissional PRIMARY KEY (NIF),
    CONSTRAINT ak_Profissional_numProfissional UNIQUE (numProfissional),
    CONSTRAINT ak_Profissional_numDocIdentificacao UNIQUE (numDocIdentificacao),
    CONSTRAINT ck_Profissional_numProfissional CHECK (numProfissional > 0),
    CONSTRAINT ck_Profissional_estado CHECK (estado IN ('Ativo', 'Inativo', 'Licença')),
    CONSTRAINT fk_Profissional_Pessoa FOREIGN KEY (NIF)
        REFERENCES Pessoa (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Profissional_Categoria FOREIGN KEY (codCategoria)
        REFERENCES Categoria (codCategoria) ON DELETE RESTRICT,
    CONSTRAINT fk_Profissional_Especialidade FOREIGN KEY (codEspecialidade)
        REFERENCES Especialidade (codEspecialidade) ON DELETE RESTRICT
);

CREATE TABLE Atuar (
    NIF               CHAR(9) NOT NULL,
    codEspecialidade  INT     NOT NULL,
    CONSTRAINT pk_Atuar PRIMARY KEY (NIF, codEspecialidade),
    CONSTRAINT fk_Atuar_Profissional FOREIGN KEY (NIF)
        REFERENCES Profissional (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Atuar_Especialidade FOREIGN KEY (codEspecialidade)
        REFERENCES Especialidade (codEspecialidade) ON DELETE RESTRICT
);

CREATE TABLE Clinica (
    localidade  VARCHAR(50)   NOT NULL,
    morada      VARCHAR(150)  NOT NULL,
    latitude    DECIMAL(9,6)  NOT NULL,
    longitude   DECIMAL(9,6)  NOT NULL,
    CONSTRAINT pk_Clinica PRIMARY KEY (localidade),
    CONSTRAINT ak_Clinica_coordenadas UNIQUE (latitude, longitude),
    CONSTRAINT ck_Clinica_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_Clinica_longitude CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE Horario (
    localidade    VARCHAR(50) NOT NULL,
    diaSemana     VARCHAR(10) NOT NULL,
    horaAbertura  TIME        NOT NULL,
    horaFecho     TIME        NOT NULL,
    CONSTRAINT pk_Horario PRIMARY KEY (localidade, diaSemana),
    CONSTRAINT ck_Horario_diaSemana CHECK (diaSemana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta')),
    CONSTRAINT ck_Horario_RIA6 CHECK (horaAbertura < horaFecho),
    CONSTRAINT fk_Horario_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade) ON DELETE CASCADE
);

CREATE TABLE Vincular (
    NIF          CHAR(9)     NOT NULL,
    localidade   VARCHAR(50) NOT NULL,
    tipoVinculo  VARCHAR(25) NOT NULL,
    CONSTRAINT pk_Vincular PRIMARY KEY (NIF, localidade),
    CONSTRAINT ck_Vincular_tipoVinculo CHECK (tipoVinculo IN
        ('contrato de trabalho', 'prestação de serviços', 'avença')),
    CONSTRAINT fk_Vincular_Profissional FOREIGN KEY (NIF)
        REFERENCES Profissional (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Vincular_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade) ON DELETE RESTRICT
);

CREATE TABLE Turno (
    NIF         CHAR(9)     NOT NULL,
    localidade  VARCHAR(50) NOT NULL,
    diaSemana   VARCHAR(10) NOT NULL,
    horaInicio  TIME        NOT NULL,
    horaFim     TIME        NOT NULL,
    CONSTRAINT pk_Turno PRIMARY KEY (NIF, localidade, diaSemana, horaInicio),
    CONSTRAINT ck_Turno_diaSemana CHECK (diaSemana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta')),
    CONSTRAINT ck_Turno_RIA6 CHECK (horaInicio < horaFim),
    CONSTRAINT fk_Turno_Vincular FOREIGN KEY (NIF, localidade)
        REFERENCES Vincular (NIF, localidade) ON DELETE CASCADE
);

CREATE TABLE Disponibilizar (
    localidade      VARCHAR(50) NOT NULL,
    diaSemana       VARCHAR(10) NOT NULL,
    codTipoCuidado  INT         NOT NULL,
    CONSTRAINT pk_Disponibilizar PRIMARY KEY (localidade, diaSemana, codTipoCuidado),
    CONSTRAINT fk_Disponibilizar_Horario FOREIGN KEY (localidade, diaSemana)
        REFERENCES Horario (localidade, diaSemana) ON DELETE RESTRICT,
    CONSTRAINT fk_Disponibilizar_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado) ON DELETE RESTRICT
);

CREATE TABLE Envolver (
    codTipoCuidado  INT NOT NULL,
    codCategoria    INT NOT NULL,
    CONSTRAINT pk_Envolver PRIMARY KEY (codTipoCuidado, codCategoria),
    CONSTRAINT fk_Envolver_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado) ON DELETE RESTRICT,
    CONSTRAINT fk_Envolver_Categoria FOREIGN KEY (codCategoria)
        REFERENCES Categoria (codCategoria) ON DELETE RESTRICT
);

CREATE TABLE AtoMedico (
    numAto            INT           NOT NULL AUTO_INCREMENT,
    dataHoraAgenda    DATETIME      NOT NULL,
    dataHoraAtend     DATETIME,
    estado            VARCHAR(10)   NOT NULL DEFAULT 'agendado',
    motivo            VARCHAR(200),
    anamnese          VARCHAR(1000),
    pressaoArterial   VARCHAR(7),
    freqCardiaca      INT,
    temperatura       DECIMAL(3,1),
    peso              DECIMAL(5,2),
    altura            DECIMAL(3,2),
    notasClinicas     VARCHAR(2000),
    planoTerapeutico  VARCHAR(1000),
    avaliacao         VARCHAR(20),
    comentario        VARCHAR(500),
    NIFUtente         CHAR(9)       NOT NULL,
    localidade        VARCHAR(50)   NOT NULL,
    codTipoCuidado    INT           NOT NULL,
    NIFPreferido      CHAR(9),
    NIFResponsavel    CHAR(9),
    CONSTRAINT pk_AtoMedico PRIMARY KEY (numAto),
    CONSTRAINT ck_AtoMedico_estado CHECK (estado IN ('agendado', 'realizado', 'cancelado', 'adiado')),
    CONSTRAINT ck_AtoMedico_avaliacao CHECK (avaliacao IN ('adorei', 'gostei', 'não pretendo voltar')),
    CONSTRAINT ck_AtoMedico_pressaoArterial CHECK (pressaoArterial REGEXP '^[0-9]{2,3}/[0-9]{2,3}$'),
    CONSTRAINT ck_AtoMedico_freqCardiaca CHECK (freqCardiaca > 0),
    CONSTRAINT ck_AtoMedico_temperatura CHECK (temperatura BETWEEN 30 AND 45),
    CONSTRAINT ck_AtoMedico_peso CHECK (peso > 0),
    CONSTRAINT ck_AtoMedico_altura CHECK (altura > 0),
    CONSTRAINT ck_AtoMedico_RIA13 CHECK (NIFResponsavel <> NIFUtente),
    CONSTRAINT ck_AtoMedico_RIA15 CHECK (estado <> 'realizado'
        OR (NIFResponsavel IS NOT NULL AND dataHoraAtend IS NOT NULL AND dataHoraAtend >= dataHoraAgenda)),
    CONSTRAINT ck_AtoMedico_RIA16 CHECK (estado = 'realizado'
        OR (dataHoraAtend IS NULL AND anamnese IS NULL AND pressaoArterial IS NULL
            AND freqCardiaca IS NULL AND temperatura IS NULL AND peso IS NULL
            AND altura IS NULL AND notasClinicas IS NULL AND planoTerapeutico IS NULL)),
    CONSTRAINT ck_AtoMedico_RIA17 CHECK (estado = 'realizado'
        OR (avaliacao IS NULL AND comentario IS NULL)),
    CONSTRAINT fk_AtoMedico_Utente FOREIGN KEY (NIFUtente)
        REFERENCES Utente (NIF),
    CONSTRAINT fk_AtoMedico_Clinica FOREIGN KEY (localidade)
        REFERENCES Clinica (localidade) ON DELETE RESTRICT,
    CONSTRAINT fk_AtoMedico_TipoCuidado FOREIGN KEY (codTipoCuidado)
        REFERENCES TipoCuidado (codTipoCuidado) ON DELETE RESTRICT,
    CONSTRAINT fk_AtoMedico_Preferido FOREIGN KEY (NIFPreferido)
        REFERENCES Profissional (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_AtoMedico_Responsavel FOREIGN KEY (NIFResponsavel)
        REFERENCES Profissional (NIF)
);

CREATE TABLE Medicamento (
    numAto          INT          NOT NULL,
    codMedicamento  INT          NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    dosagem         VARCHAR(50)  NOT NULL,
    posologia       VARCHAR(100) NOT NULL,
    durTratamento   INT          NOT NULL,
    CONSTRAINT pk_Medicamento PRIMARY KEY (numAto, codMedicamento),
    CONSTRAINT ck_Medicamento_codMedicamento CHECK (codMedicamento > 0),
    CONSTRAINT ck_Medicamento_durTratamento CHECK (durTratamento > 0),
    CONSTRAINT fk_Medicamento_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto) ON DELETE CASCADE
);

CREATE TABLE Requisicao (
    numAto         INT           NOT NULL,
    numRequisicao  INT           NOT NULL,
    tipoExame      VARCHAR(100)  NOT NULL,
    data           DATE          NOT NULL,
    estado         VARCHAR(10)   NOT NULL DEFAULT 'pendente',
    resultado      VARCHAR(1000),
    CONSTRAINT pk_Requisicao PRIMARY KEY (numAto, numRequisicao),
    CONSTRAINT ck_Requisicao_numRequisicao CHECK (numRequisicao > 0),
    CONSTRAINT ck_Requisicao_estado CHECK (estado IN ('pendente', 'realizada')),
    CONSTRAINT ck_Requisicao_RIA19 CHECK (estado = 'realizada' OR resultado IS NULL),
    CONSTRAINT fk_Requisicao_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto) ON DELETE CASCADE
);

CREATE TABLE Anexo (
    numAto         INT          NOT NULL,
    numRequisicao  INT          NOT NULL,
    numAnexo       INT          NOT NULL,
    nomeFicheiro   VARCHAR(100) NOT NULL,
    tipo           VARCHAR(10)  NOT NULL,
    ficheiro       VARCHAR(255) NOT NULL,
    dataUpload     DATETIME     NOT NULL,
    CONSTRAINT pk_Anexo PRIMARY KEY (numAto, numRequisicao, numAnexo),
    CONSTRAINT ck_Anexo_numAnexo CHECK (numAnexo > 0),
    CONSTRAINT ck_Anexo_tipo CHECK (tipo IN ('relatório', 'imagem', 'outro')),
    CONSTRAINT fk_Anexo_Requisicao FOREIGN KEY (numAto, numRequisicao)
        REFERENCES Requisicao (numAto, numRequisicao) ON DELETE CASCADE
);

CREATE TABLE Diagnosticar (
    numAto    INT         NOT NULL,
    codICD11  VARCHAR(10) NOT NULL,
    CONSTRAINT pk_Diagnosticar PRIMARY KEY (numAto, codICD11),
    CONSTRAINT fk_Diagnosticar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto) ON DELETE RESTRICT,
    CONSTRAINT fk_Diagnosticar_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11) ON DELETE RESTRICT
);

CREATE TABLE Executar (
    numAto           INT NOT NULL,
    codProcedimento  INT NOT NULL,
    CONSTRAINT pk_Executar PRIMARY KEY (numAto, codProcedimento),
    CONSTRAINT fk_Executar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto) ON DELETE RESTRICT,
    CONSTRAINT fk_Executar_Procedimento FOREIGN KEY (codProcedimento)
        REFERENCES Procedimento (codProcedimento) ON DELETE RESTRICT
);

CREATE TABLE Administrar (
    numAto     INT         NOT NULL,
    codVacina  INT         NOT NULL,
    numDose    INT         NOT NULL,
    lote       VARCHAR(20) NOT NULL,
    CONSTRAINT pk_Administrar PRIMARY KEY (numAto, codVacina),
    CONSTRAINT ck_Administrar_numDose CHECK (numDose > 0),
    CONSTRAINT fk_Administrar_AtoMedico FOREIGN KEY (numAto)
        REFERENCES AtoMedico (numAto) ON DELETE RESTRICT,
    CONSTRAINT fk_Administrar_Vacina FOREIGN KEY (codVacina)
        REFERENCES Vacina (codVacina) ON DELETE RESTRICT
);

CREATE TABLE Planear (
    NIF           CHAR(9) NOT NULL,
    codVacina     INT     NOT NULL,
    dataPrevista  DATE    NOT NULL,
    CONSTRAINT pk_Planear PRIMARY KEY (NIF, codVacina),
    CONSTRAINT fk_Planear_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Planear_Vacina FOREIGN KEY (codVacina)
        REFERENCES Vacina (codVacina) ON DELETE RESTRICT
);

CREATE TABLE Padecer (
    NIF       CHAR(9)     NOT NULL,
    codICD11  VARCHAR(10) NOT NULL,
    CONSTRAINT pk_Padecer PRIMARY KEY (NIF, codICD11),
    CONSTRAINT fk_Padecer_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Padecer_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11) ON DELETE RESTRICT
);

CREATE TABLE Herdar (
    NIF         CHAR(9)     NOT NULL,
    codICD11    VARCHAR(10) NOT NULL,
    grauParent  VARCHAR(10) NOT NULL,
    CONSTRAINT pk_Herdar PRIMARY KEY (NIF, codICD11),
    CONSTRAINT ck_Herdar_RIA5 CHECK (grauParent IN ('pai', 'mãe', 'irmão', 'irmã', 'filho', 'filha')),
    CONSTRAINT fk_Herdar_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Herdar_Patologia FOREIGN KEY (codICD11)
        REFERENCES Patologia (codICD11) ON DELETE RESTRICT
);

CREATE TABLE Reagir (
    NIF           CHAR(9)      NOT NULL,
    codAlergenio  INT          NOT NULL,
    reacao        VARCHAR(200) NOT NULL,
    CONSTRAINT pk_Reagir PRIMARY KEY (NIF, codAlergenio),
    CONSTRAINT fk_Reagir_Utente FOREIGN KEY (NIF)
        REFERENCES Utente (NIF) ON DELETE RESTRICT,
    CONSTRAINT fk_Reagir_Alergenio FOREIGN KEY (codAlergenio)
        REFERENCES Alergenio (codAlergenio) ON DELETE RESTRICT
);

CREATE OR REPLACE VIEW vPessoa AS
SELECT P.*,
       TIMESTAMPDIFF(YEAR, P.dataNascimento, CURDATE()) AS idade
FROM Pessoa P;

CREATE OR REPLACE VIEW vAtoMedico AS
SELECT A.*,
       ROUND(A.peso / (A.altura * A.altura), 1) AS IMC
FROM AtoMedico A;