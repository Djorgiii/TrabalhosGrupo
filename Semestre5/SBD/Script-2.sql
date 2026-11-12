
--  3.2 Script SQL DML para carregamento de dados de demonstração
--
--  Organização:
--    Bloco 0 - Dados comuns a todas as clínicas (grupo)
--    Bloco 1 - Clínica do Montijo  (Jorge Gonçalves, A52345)
--    Bloco 2 - Clínica de Guimaraes (Helena Nina, A52708)
--    Bloco 3 - Clínica de Sintra  (Margarida Andrade, A52146)
--
--  Os blocos têm de ser corridos por esta ordem.
--  Para não haver conflitos, cada elemento usa uma gama própria de números:
--    numAto: Lisboa 101-199 | Guimaraes 201-299 | Sintra 301-399
-- =====================================================================

USE clinica;



-- BLOCO 0 - DADOS COMUNS (tabelas de referência, partilhadas por todos)

INSERT INTO Categoria (designacao) VALUES
    ('Médico'),                                           -- 1
    ('Enfermeiro'),                                       -- 2
    ('Técnico Superior de Diagnóstico e Terapêutica'),    -- 3
    ('Fisioterapeuta'),                                   -- 4
    ('Psicólogo'),                                        -- 5
    ('Auxiliar de Ação Médica');                          -- 6

INSERT INTO Especialidade (designacao) VALUES
    ('Medicina Geral e Familiar'),   -- 1
    ('Cardiologia'),                 -- 2
    ('Pediatria'),                   -- 3
    ('Dermatologia'),                -- 4
    ('Ortopedia');                   -- 5

INSERT INTO TipoCuidado (designacao) VALUES
    ('Consultas Médicas de Especialidade'),               -- 1
    ('Exames Complementares de Diagnóstico'),             -- 2
    ('Intervenções Cirúrgicas e Bloco Ambulatório'),      -- 3
    ('Medicina Preventiva e Promoção da Saúde'),          -- 4
    ('Tratamentos Terapêuticos e Atos de Enfermagem'),    -- 5
    ('Reabilitação e Fisioterapia'),                      -- 6
    ('Saúde Mental e Acompanhamento Psicológico');        -- 7

INSERT INTO Envolver (codTipoCuidado, codCategoria) VALUES
    (1, 1),           -- Consultas: Médico
    (2, 3),           -- Exames: TSDT
    (3, 1), (3, 2),   -- Intervenções cirúrgicas: Médico e Enfermeiro
    (4, 1), (4, 2),   -- Medicina preventiva: Médico e Enfermeiro
    (5, 2),           -- Tratamentos e atos de enfermagem: Enfermeiro
    (6, 4),           -- Reabilitação: Fisioterapeuta
    (7, 5);           -- Saúde mental: Psicólogo

INSERT INTO Patologia (codICD11, designacao) VALUES
    ('5A11', 'Diabetes mellitus tipo 2'),
    ('BA00', 'Hipertensão essencial'),
    ('CA23', 'Asma'),
    ('BA41', 'Enfarte agudo do miocárdio');

INSERT INTO Procedimento (designacao, tipo) VALUES
    ('Excisão de quisto sebáceo', 'cirurgia'),            -- 1
    ('Sessão de fisioterapia', 'tratamento'),             -- 2
    ('Administração de injetável', 'ato de enfermagem'),  -- 3
    ('Penso simples', 'ato de enfermagem');               -- 4

INSERT INTO Vacina (nome) VALUES
    ('Gripe'),                    -- 1
    ('Tétano e difteria (Td)'),   -- 2
    ('COVID-19');                 -- 3

INSERT INTO Alergenio (designacao, tipo) VALUES
    ('Penicilina', 'medicamentoso'),          -- 1
    ('Amendoim', 'alimentar'),                -- 2
    ('Pólen de gramíneas', 'ambiental');      -- 3


-- BLOCO 1 - CLÍNICA Jorge Gonçalves (A52345)
-- Clínica e horário (dias úteis, das 09:00 às 18:00)
INSERT INTO Clinica (localidade, morada, latitude, longitude) VALUES
    ('Montijo', 'Rua das Papoilas', 38.71152, -8.98198);

INSERT INTO Horario (localidade, diaSemana, horaAbertura, horaFecho) VALUES
    ('Montijo', 'segunda', '09:00', '18:00'),
    ('Montijo', 'terça',   '09:00', '18:00'),
    ('Montijo', 'quarta',  '09:00', '18:00'),
    ('Montijo', 'quinta',  '09:00', '18:00'),
    ('Montijo', 'sexta',   '09:00', '18:00');

-- Tipos de cuidado disponíveis: consultas (1) e atos de enfermagem (5)
INSERT INTO Disponibilizar (localidade, diaSemana, codTipoCuidado) VALUES
    ('Montijo', 'segunda', 1), ('Montijo', 'segunda', 5),
    ('Montijo', 'terça',   1), ('Montijo', 'terça',   5),
    ('Montijo', 'quarta',  1), ('Montijo', 'quarta',  5),
    ('Montijo', 'quinta',  1), ('Montijo', 'quinta',  5),
    ('Montijo', 'sexta',   1), ('Montijo', 'sexta',   5);

-- Pessoas: 2 profissionais (Ana, Bruno) e 1 utente (Gonçalo).
-- O Bruno também é utente (generalização sobreposta).
INSERT INTO Pessoa (NIF, nomeCompleto, dataNascimento, genero, morada, pais, distrito, concelho, freguesia) VALUES
    ('211111111', 'Ana Sofia Ribeiro',     '1980-03-14', 'F', 'Rua Almirante Cândido dos Reis, 20', 'Portugal', 'Setúbal', 'Montijo', 'Montijo e Afonsoeiro'),
    ('212222222', 'Bruno Miguel Carvalho', '1990-07-02', 'M', 'Av. dos Pescadores, 5',              'Portugal', 'Setúbal', 'Montijo', 'Atalaia e Alto Estanqueiro-Jardia'),
    ('221111111', 'Gonçalo Lopes',         '1965-02-25', 'M', 'Rua Bulhão Pato, 33',                'Portugal', 'Setúbal', 'Montijo', 'Montijo e Afonsoeiro');

INSERT INTO Telefone (NIF, telefone) VALUES
    ('211111111', '912345678'),
    ('212222222', '923456789'),
    ('221111111', '961111111'),
    ('221111111', '212345678');
INSERT INTO Email (NIF, email) VALUES
    ('211111111', 'ana.ribeiro@nexumvitae.pt'),
    ('212222222', 'bruno.carvalho@nexumvitae.pt'),
    ('221111111', 'goncalo.lopes@gmail.com'),
    ('221111111', 'glopes@empresa.pt');

-- Profissionais (a médica tem especialidade principal - RIA3)
INSERT INTO Profissional (NIF, numProfissional, numDocIdentificacao, nomeClinico, fotografia, estado, codCategoria, codEspecialidade) VALUES
    ('211111111', 10001, '12345678', 'Dra. Ana Ribeiro',    'fotos/ana_ribeiro.jpg',    'Ativo', 1, 1),
    ('212222222', 20001, '23456789', 'Enf. Bruno Carvalho', 'fotos/bruno_carvalho.jpg', 'Ativo', 2, NULL);

INSERT INTO Atuar (NIF, codEspecialidade) VALUES
    ('211111111', 2);

INSERT INTO Vincular (NIF, localidade, tipoVinculo) VALUES
    ('211111111', 'Montijo', 'contrato de trabalho'),
    ('212222222', 'Montijo', 'contrato de trabalho');

-- Turnos dentro do horário da clínica (RIA7)
INSERT INTO Turno (NIF, localidade, diaSemana, horaInicio, horaFim) VALUES
    ('211111111', 'Montijo', 'segunda', '09:00', '13:00'),
    ('211111111', 'Montijo', 'quarta',  '09:00', '13:00'),
    ('212222222', 'Montijo', 'segunda', '09:00', '17:00'),
    ('212222222', 'Montijo', 'terça',   '09:00', '17:00');

-- Utentes (o contacto de emergência não é o próprio utente - RIA2)
INSERT INTO Utente (NIF, numSNS, grupoSanguineo, nomeContactoEmerg, parentContactoEmerg, telContactoEmerg, estiloVida) VALUES
    ('221111111', '100000001', 'A+', 'Maria Lopes',   'esposa', '961222333', 'Sedentário, ex-fumador'),
    ('212222222', '100000005', NULL, 'Sara Carvalho', 'irmã',   '926000111', NULL);

INSERT INTO PrefLingCultural (NIF, prefLingCultural) VALUES
    ('221111111', 'Prefere atendimento por médico do sexo masculino');

INSERT INTO AnteCirurgico (NIF, anteCirurgico) VALUES
    ('221111111', 'Apendicectomia (1990)'),
    ('221111111', 'Cateterismo cardíaco (2019)');

-- Histórico clínico do Gonçalo
INSERT INTO Padecer (NIF, codICD11) VALUES
    ('221111111', '5A11'),
    ('221111111', 'BA00');

INSERT INTO Herdar (NIF, codICD11, grauParent) VALUES
    ('221111111', 'BA41', 'pai');

INSERT INTO Reagir (NIF, codAlergenio, reacao) VALUES
    ('221111111', 1, 'Urticária generalizada');

-- Plano de vacinação (tem de existir antes de administrar - RIA20)
INSERT INTO Planear (NIF, codVacina, dataPrevista) VALUES
    ('221111111', 1, '2026-10-12'),
    ('221111111', 2, '2026-10-05');

-- Atos médicos (numAto 101-199)
INSERT INTO AtoMedico (numAto, dataHoraAgenda, dataHoraAtend, estado, motivo, anamnese, pressaoArterial, freqCardiaca,
                       temperatura, peso, altura, notasClinicas, planoTerapeutico, avaliacao, comentario,
                       NIFUtente, localidade, codTipoCuidado, NIFPreferido, NIFResponsavel) VALUES
    -- 101: consulta do Gonçalo com a Dra. Ana (segunda 5/10, turno dela 09-13)
    (101, '2026-10-05 10:00', '2026-10-05 10:05', 'realizado', 'Controlo da diabetes e da tensão arterial',
     'Refere cansaço e sede frequente', '145/90', 78, 36.6, 92.40, 1.75,
     'Glicemia elevada; tensão acima do normal', 'Ajustar medicação e repetir análises em 3 meses',
     'adorei', 'Médica muito atenciosa', '221111111', 'Montijo', 1, '211111111', '211111111'),
    -- 102: ato de enfermagem do Gonçalo com o Enf. Bruno (segunda 12/10, turno dele 09-17)
    (102, '2026-10-12 09:30', '2026-10-12 09:35', 'realizado', 'Vacinação e penso',
     'Pequena ferida na mão', '138/88', 74, 36.5, 92.00, 1.75,
     'Ferida limpa, sem sinais de infeção', 'Mudar penso daqui a 3 dias', 'gostei', NULL,
     '221111111', 'Montijo', 5, NULL, '212222222'),
    -- 103: consulta agendada do Bruno (como utente) com a Dra. Ana (segunda 16/11)
    (103, '2026-11-16 11:00', NULL, 'agendado', 'Check-up anual', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '212222222', 'Montijo', 1, '211111111', NULL);

INSERT INTO Medicamento (numAto, codMedicamento, nome, dosagem, posologia, durTratamento) VALUES
    (101, 1, 'Metformina', '850 mg', '1 comprimido ao pequeno-almoço e ao jantar', 90),
    (101, 2, 'Lisinopril', '10 mg',  '1 comprimido por dia, de manhã',             90);

INSERT INTO Requisicao (numAto, numRequisicao, tipoExame, data, estado, resultado) VALUES
    (101, 1, 'Análises ao sangue (glicemia e HbA1c)', '2026-10-05', 'realizada', 'HbA1c de 7,8%; glicemia em jejum de 160 mg/dL'),
    (101, 2, 'Eletrocardiograma',                     '2026-10-05', 'realizada', 'Ritmo sinusal, sem alterações');

INSERT INTO Anexo (numAto, numRequisicao, numAnexo, nomeFicheiro, tipo, ficheiro, dataUpload) VALUES
    (101, 1, 1, 'analises_goncalo.pdf',    'relatório', 'anexos/2026/10/analises_goncalo.pdf', '2026-10-08 14:00'),
    (101, 1, 2, 'boletim_laboratorio.pdf', 'relatório', 'anexos/2026/10/boletim_lab.pdf',      '2026-10-08 14:01'),
    (101, 2, 1, 'ecg_goncalo.png',         'imagem',    'anexos/2026/10/ecg_goncalo.png',      '2026-10-05 11:00');

INSERT INTO Diagnosticar (numAto, codICD11) VALUES
    (101, '5A11'),
    (101, 'BA00');

INSERT INTO Executar (numAto, codProcedimento) VALUES
    (102, 3),   -- administração de injetável
    (102, 4);   -- penso simples

INSERT INTO Administrar (numAto, codVacina, numDose, lote) VALUES
    (101, 2, 1, 'TD2026-0451'),   -- tétano, 1.ª dose
    (102, 1, 1, 'GR2026-1180');   -- gripe, 1.ª dose

-- BLOCO 2 - CLÍNICA DE  Helena Nina (A52708)

INSERT INTO Clinica (localidade, morada, latitude, longitude) VALUES
    ('Guimaraes', 'Alameda Dr. Alfredo Pimenta', 41.4481, -8.29954);

INSERT INTO Horario (localidade, diaSemana, horaAbertura, horaFecho) VALUES
    ('Guimaraes', 'segunda', '08:30', '19:00'),
    ('Guimaraes', 'terça',   '08:30', '19:00'),
    ('Guimaraes', 'quarta',  '08:30', '19:00'),
    ('Guimaraes', 'quinta',  '08:30', '19:00'),
    ('Guimaraes', 'sexta',   '08:30', '19:00');

INSERT INTO Disponibilizar (localidade, diaSemana, codTipoCuidado) VALUES
    ('Guimaraes', 'segunda', 1), ('Guimaraes', 'segunda', 6),
    ('Guimaraes', 'terça',   1), ('Guimaraes', 'terça',   6),
    ('Guimaraes', 'quarta',  1), ('Guimaraes', 'quarta',  6),
    ('Guimaraes', 'quinta',  1), ('Guimaraes', 'quinta',  6),
    ('Guimaraes', 'sexta',   1), ('Guimaraes', 'sexta',   6);

INSERT INTO Pessoa (NIF, nomeCompleto, dataNascimento, genero, morada, pais, distrito, concelho, freguesia) VALUES
    ('213333333', 'Carla Mendes', '1975-11-20', 'F', 'Rua Almirante Reis, 8',            'Portugal', 'Guimaraes', 'Guimaraes', 'São Sebastião'),
    ('214444444', 'Duarte Pires', '1988-01-30', 'M', 'Av. Luísa Todi, 150',              'Portugal', 'Guimaraes', 'Guimaraes', 'São Julião'),
    ('222222222', 'Helena Costa', '1995-12-01', 'F', 'Rua Dr. António Manuel Gamito, 5', 'Portugal', 'Guimaraes', 'Guimaraes', 'São Sebastião');

INSERT INTO Telefone (NIF, telefone) VALUES
    ('213333333', '934567890');

INSERT INTO Profissional (NIF, numProfissional, numDocIdentificacao, nomeClinico, fotografia, estado, codCategoria, codEspecialidade) VALUES
    ('213333333', 10002, '34567890', 'Dra. Carla Mendes', 'fotos/carla_mendes.jpg', 'Ativo', 1, 2),
    ('214444444', 30001, '45678901', 'Ft. Duarte Pires',  'fotos/duarte_pires.jpg', 'Ativo', 4, NULL);

INSERT INTO Atuar (NIF, codEspecialidade) VALUES
    ('213333333', 1);   -- Carla: Medicina Geral e Familiar

INSERT INTO Vincular (NIF, localidade, tipoVinculo) VALUES
    ('213333333', 'Guimaraes', 'contrato de trabalho'),
    ('214444444', 'Guimaraes', 'avença');

INSERT INTO Turno (NIF, localidade, diaSemana, horaInicio, horaFim) VALUES
    ('213333333', 'Guimaraes', 'terça',   '09:00', '17:00'),
    ('214444444', 'Guimaraes', 'segunda', '09:00', '13:00');

INSERT INTO Utente (NIF, numSNS, grupoSanguineo, nomeContactoEmerg, parentContactoEmerg, telContactoEmerg, estiloVida) VALUES
    ('222222222', '100000002', 'O-', 'Rui Costa', 'pai', '965444555', 'Pratica corrida 3 vezes por semana');

INSERT INTO Herdar (NIF, codICD11, grauParent) VALUES
    ('222222222', '5A11', 'mãe');

INSERT INTO Reagir (NIF, codAlergenio, reacao) VALUES
    ('222222222', 3, 'Rinite na primavera');

INSERT INTO AtoMedico (numAto, dataHoraAgenda, dataHoraAtend, estado, motivo, anamnese, pressaoArterial, freqCardiaca,
                       temperatura, peso, altura, notasClinicas, planoTerapeutico, avaliacao, comentario,
                       NIFUtente, localidade, codTipoCuidado, NIFPreferido, NIFResponsavel) VALUES
    -- sessão de fisioterapia da Helena com o Duarte (segunda-feira)
    (201, '2026-10-05 10:00', '2026-10-05 10:00', 'realizado', 'Dor lombar após esforço',
     'Dor lombar há duas semanas', '118/76', 66, 36.4, 61.00, 1.68,
     'Contratura muscular lombar', '6 sessões de fisioterapia', 'gostei', NULL,
     '222222222', 'Guimaraes', 6, NULL, '214444444'),
    -- consulta cancelada da Helena com a Dra. Carla (terça-feira)
    (202, '2026-11-17 10:00', NULL, 'cancelado', 'Dores de cabeça frequentes', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '222222222', 'Guimaraes', 1, '213333333', NULL);

INSERT INTO Executar (numAto, codProcedimento) VALUES
    (201, 2);   -- sessão de fisioterapia



-- BLOCO 3 - CLÍNICA DE  Margarida Andrade (A52146)





-- #####################################################################
-- VERIFICAÇÃO
SELECT * FROM Clinica;
SELECT * FROM AtoMedico;
