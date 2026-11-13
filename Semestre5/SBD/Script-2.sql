

USE nexumvitae;

INSERT INTO Categoria (designacao) VALUES
    ('Médico'),
    ('Enfermeiro'),
    ('Técnico Superior de Diagnóstico e Terapêutica'),
    ('Fisioterapeuta'),
    ('Psicólogo'),
    ('Auxiliar de Ação Médica');

INSERT INTO Especialidade (designacao) VALUES
    ('Medicina Geral e Familiar'),
    ('Cardiologia'),
    ('Pediatria'),
    ('Dermatologia'),
    ('Ortopedia');

INSERT INTO TipoCuidado (designacao) VALUES
    ('Consultas Médicas de Especialidade'),
    ('Exames Complementares de Diagnóstico'),
    ('Intervenções Cirúrgicas e Bloco Ambulatório'),
    ('Medicina Preventiva e Promoção da Saúde'),
    ('Tratamentos Terapêuticos e Atos de Enfermagem'),
    ('Reabilitação e Fisioterapia'),
    ('Saúde Mental e Acompanhamento Psicológico');

-- Categorias que participam em cada tipo de cuidado (usada pela RIA12).
INSERT INTO Envolver (codTipoCuidado, codCategoria)
SELECT t.codTipoCuidado, c.codCategoria
FROM TipoCuidado t, Categoria c
WHERE (t.designacao, c.designacao) IN (
    ('Consultas Médicas de Especialidade',            'Médico'),
    ('Exames Complementares de Diagnóstico',          'Técnico Superior de Diagnóstico e Terapêutica'),
    ('Intervenções Cirúrgicas e Bloco Ambulatório',   'Médico'),
    ('Intervenções Cirúrgicas e Bloco Ambulatório',   'Enfermeiro'),
    ('Medicina Preventiva e Promoção da Saúde',       'Médico'),
    ('Medicina Preventiva e Promoção da Saúde',       'Enfermeiro'),
    ('Tratamentos Terapêuticos e Atos de Enfermagem', 'Enfermeiro'),
    ('Reabilitação e Fisioterapia',                   'Fisioterapeuta'),
    ('Saúde Mental e Acompanhamento Psicológico',     'Psicólogo'));

INSERT INTO Patologia (codICD11, designacao) VALUES
    ('5A11', 'Diabetes mellitus tipo 2'),
    ('BA00', 'Hipertensão essencial'),
    ('CA23', 'Asma'),
    ('BA41', 'Enfarte agudo do miocárdio');

INSERT INTO Procedimento (designacao, tipo) VALUES
    ('Excisão de quisto sebáceo', 'cirurgia'),
    ('Sessão de fisioterapia', 'tratamento'),
    ('Administração de injetável', 'ato de enfermagem'),
    ('Penso simples', 'ato de enfermagem');

INSERT INTO Vacina (nome) VALUES
    ('Gripe'),
    ('Tétano e difteria (Td)'),
    ('COVID-19');

INSERT INTO Alergenio (designacao, tipo) VALUES
    ('Penicilina', 'medicamentoso'),
    ('Amendoim', 'alimentar'),
    ('Pólen de gramíneas', 'ambiental');


-- Clinica 1 - Jorge - Montijo


-- Clínica e horário (dias úteis, das 09:00 às 18:00)
INSERT INTO Clinica (localidade, morada, latitude, longitude) VALUES
    ('Montijo', 'Rua das Papoilas', 38.711520, -8.981980);

INSERT INTO Horario (localidade, diaSemana, horaAbertura, horaFecho) VALUES
    ('Montijo', 'segunda', '09:00', '18:00'),
    ('Montijo', 'terça',   '09:00', '18:00'),
    ('Montijo', 'quarta',  '09:00', '18:00'),
    ('Montijo', 'quinta',  '09:00', '18:00'),
    ('Montijo', 'sexta',   '09:00', '18:00');

-- Em todos os dias do horário há consultas e atos de enfermagem.
INSERT INTO Disponibilizar (localidade, diaSemana, codTipoCuidado)
SELECT h.localidade, h.diaSemana, t.codTipoCuidado
FROM Horario h, TipoCuidado t
WHERE h.localidade = 'Montijo'
  AND t.designacao IN ('Consultas Médicas de Especialidade', 'Tratamentos Terapêuticos e Atos de Enfermagem');

-- Pessoas: 2 profissionais (Ana, Bruno) e 1 utente (Gonçalo).
-- O Bruno é inserido também em Utente, mais abaixo: exemplo da generalização
-- sobreposta (o mesmo NIF em Profissional e em Utente).
INSERT INTO Pessoa (NIF, nomeCompleto, dataNascimento, genero, morada, pais, distrito, concelho, freguesia) VALUES
    ('211111111', 'Ana Sofia Ribeiro',     '1980-03-14', 'F', 'Rua Almirante Cândido dos Reis, 20', 'Portugal', 'Setúbal', 'Montijo', 'Montijo e Afonsoeiro'),
    ('212222222', 'Bruno Miguel Carvalho', '1990-07-02', 'M', 'Av. dos Pescadores, 5',              'Portugal', 'Setúbal', 'Montijo', 'Atalaia e Alto Estanqueiro-Jardia'),
    ('221111111', 'Gonçalo Lopes',         '1965-02-25', 'M', 'Rua Bulhão Pato, 33',                'Portugal', 'Setúbal', 'Montijo', 'Montijo e Afonsoeiro');

INSERT INTO PessoaTelefone (NIF, telefone) VALUES
    ('211111111', '912345678'),
    ('212222222', '923456789'),
    ('221111111', '961111111'),
    ('221111111', '212345678');

INSERT INTO PessoaEmail (NIF, email) VALUES
    ('211111111', 'ana.ribeiro@nexumvitae.pt'),
    ('212222222', 'bruno.carvalho@nexumvitae.pt'),
    ('221111111', 'goncalo.lopes@gmail.com'),
    ('221111111', 'glopes@empresa.pt');

-- Profissionais (a médica tem especialidade principal - RIA3)
INSERT INTO Profissional (NIF, numProfissional, numDocIdentificacao, nomeClinico, fotografia, estado, codCategoria, codEspecialidade) VALUES
    ('211111111', 10001, '12345678', 'Dra. Ana Ribeiro',    'fotos/ana_ribeiro.jpg',    'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Médico'), (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Medicina Geral e Familiar')),
    ('212222222', 20001, '23456789', 'Enf. Bruno Carvalho', 'fotos/bruno_carvalho.jpg', 'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Enfermeiro'), NULL);

-- Área de atuação diferente da especialidade principal (RIA4)
INSERT INTO Atuar (NIF, codEspecialidade) VALUES
    ('211111111', (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Cardiologia'));

INSERT INTO Vincular (NIF, localidade, tipoVinculo) VALUES
    ('211111111', 'Montijo', 'contrato de trabalho'),
    ('212222222', 'Montijo', 'contrato de trabalho');

-- Turnos dentro do horário da clínica (RIA7) e sem sobreposições (RIA8)
INSERT INTO Turno (NIF, localidade, diaSemana, horaInicio, horaFim) VALUES
    ('211111111', 'Montijo', 'segunda', '09:00', '13:00'),
    ('211111111', 'Montijo', 'quarta',  '09:00', '13:00'),
    ('212222222', 'Montijo', 'segunda', '09:00', '17:00'),
    ('212222222', 'Montijo', 'terça',   '09:00', '17:00');

-- Utentes (o contacto de emergência não é o próprio utente - RIA2)
INSERT INTO Utente (NIF, numSNS, grupoSanguineo, nomeContactoEmerg, parentContactoEmerg, telContactoEmerg, estiloVida) VALUES
    ('221111111', '100000001', 'A+', 'Maria Lopes',   'esposa', '961222333', 'Sedentário, ex-fumador'),
    ('212222222', '100000005', 'B+', 'Sara Carvalho', 'irmã',   '926000111', NULL);

INSERT INTO UtentePrefLingCulturais (NIF, prefLingCulturais) VALUES
    ('221111111', 'Prefere atendimento por médico do sexo masculino');

INSERT INTO UtenteAnteCirurgico (NIF, anteCirurgico) VALUES
    ('221111111', 'Apendicectomia (1990)'),
    ('221111111', 'Cateterismo cardíaco (2019)');

-- Histórico clínico do Gonçalo
INSERT INTO Padecer (NIF, codICD11) VALUES
    ('221111111', '5A11'),
    ('221111111', 'BA00');

INSERT INTO Herdar (NIF, codICD11, grauParent) VALUES
    ('221111111', 'BA41', 'pai');

INSERT INTO Reagir (NIF, codAlergenio, reacao) VALUES
    ('221111111', (SELECT codAlergenio FROM Alergenio WHERE designacao = 'Penicilina'), 'Urticária generalizada');

-- Plano de vacinação (tem de existir antes de administrar - RIA20)
INSERT INTO Planear (NIF, codVacina, dataPrevista) VALUES
    ('221111111', (SELECT codVacina FROM Vacina WHERE nome = 'Gripe'), '2026-10-12'),
    ('221111111', (SELECT codVacina FROM Vacina WHERE nome = 'Tétano e difteria (Td)'), '2026-10-05');


INSERT INTO AtoMedico (numAto, dataHoraAgenda, dataHoraAtend, estado, motivo, anamnese, pressaoArterial, freqCardiaca,
                       temperatura, peso, altura, notasClinicas, planoTerapeutico, avaliacao, comentario,
                       NIFUtente, localidade, codTipoCuidado, NIFPreferido, NIFResponsavel) VALUES
    -- 101: consulta do Gonçalo com a Dra. Ana (segunda 05/10, turno dela 09-13)
    (101, '2026-10-05 10:00', '2026-10-05 10:05', 'realizado', 'Controlo da diabetes e da tensão arterial',
     'Refere cansaço e sede frequente', '145/90', 78, 36.6, 92.40, 1.75,
     'Glicemia elevada; tensão acima do normal', 'Ajustar medicação e repetir análises em 3 meses',
     'adorei', 'Médica muito atenciosa', '221111111', 'Montijo', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '211111111', '211111111'),
    -- 102: ato de enfermagem do Gonçalo com o Enf. Bruno (segunda 12/10, turno dele 09-17)
    (102, '2026-10-12 09:30', '2026-10-12 09:35', 'realizado', 'Vacinação e penso',
     'Pequena ferida na mão', '138/88', 74, 36.5, 92.00, 1.75,
     'Ferida limpa, sem sinais de infeção', 'Mudar penso daqui a 3 dias', 'gostei', NULL,
     '221111111', 'Montijo', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Tratamentos Terapêuticos e Atos de Enfermagem'),
     NULL, '212222222'),
    -- 103: consulta agendada do Bruno (como utente) com a Dra. Ana (segunda 16/11)
    (103, '2026-11-16 11:00', NULL, 'agendado', 'Check-up anual', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '212222222', 'Montijo', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '211111111', NULL);

INSERT INTO Medicamento (numAto, codMedicamento, nome, dosagem, posologia, durTratamento) VALUES
    (101, 1, 'Metformina', '850 mg', '1 comprimido ao pequeno-almoço e ao jantar', 90),
    (101, 2, 'Lisinopril', '10 mg',  '1 comprimido por dia, de manhã',             90);

INSERT INTO Requisicao (numAto, numRequisicao, tipoExame, data, estado, resultado) VALUES
    (101, 1, 'Análises ao sangue (glicemia e HbA1c)', '2026-10-05', 'realizada', 'HbA1c de 7,8%; glicemia em jejum de 160 mg/dL'),
    (101, 2, 'Eletrocardiograma',                     '2026-10-05', 'realizada', 'Ritmo sinusal, sem alterações');

-- Anexos só em requisições 'realizada' (RIA19).
INSERT INTO Anexo (numAto, numRequisicao, numAnexo, nomeFicheiro, tipo, ficheiro, dataUpload) VALUES
    (101, 1, 1, 'analises_goncalo.pdf',    'relatório', 'anexos/2026/10/analises_goncalo.pdf', '2026-10-08 14:00'),
    (101, 1, 2, 'boletim_laboratorio.pdf', 'relatório', 'anexos/2026/10/boletim_lab.pdf',      '2026-10-08 14:01'),
    (101, 2, 1, 'ecg_goncalo.png',         'imagem',    'anexos/2026/10/ecg_goncalo.png',      '2026-10-05 11:00');

INSERT INTO Diagnosticar (numAto, codICD11) VALUES
    (101, '5A11'),
    (101, 'BA00');

INSERT INTO Executar (numAto, codProcedimento) VALUES
    (102, (SELECT codProcedimento FROM Procedimento WHERE designacao = 'Administração de injetável')),
    (102, (SELECT codProcedimento FROM Procedimento WHERE designacao = 'Penso simples'));

-- Só vacinas que constam no plano do utente (RIA20), começando pela 1.ª dose (RIA21).
INSERT INTO Administrar (numAto, codVacina, numDose, lote) VALUES
    (101, (SELECT codVacina FROM Vacina WHERE nome = 'Tétano e difteria (Td)'), 1, 'TD2026-0451'),
    (102, (SELECT codVacina FROM Vacina WHERE nome = 'Gripe'), 1, 'GR2026-1180');



--  Clinica 2 - Helena - Guimarães

-- Clínica e horário (dias úteis, das 08:30 às 19:00)
INSERT INTO Clinica (localidade, morada, latitude, longitude) VALUES
    ('Guimarães', 'Alameda Dr. Alfredo Pimenta', 41.448100, -8.299540);

INSERT INTO Horario (localidade, diaSemana, horaAbertura, horaFecho) VALUES
    ('Guimarães', 'segunda', '08:30', '19:00'),
    ('Guimarães', 'terça',   '08:30', '19:00'),
    ('Guimarães', 'quarta',  '08:30', '19:00'),
    ('Guimarães', 'quinta',  '08:30', '19:00'),
    ('Guimarães', 'sexta',   '08:30', '19:00');

-- Em todos os dias do horário há consultas e reabilitação/fisioterapia.
INSERT INTO Disponibilizar (localidade, diaSemana, codTipoCuidado)
SELECT h.localidade, h.diaSemana, t.codTipoCuidado
FROM Horario h, TipoCuidado t
WHERE h.localidade = 'Guimarães'
  AND t.designacao IN ('Consultas Médicas de Especialidade', 'Reabilitação e Fisioterapia');

-- Pessoas: 2 profissionais (Carla, Duarte) e 2 utentes (Helena, Tiago)
INSERT INTO Pessoa (NIF, nomeCompleto, dataNascimento, genero, morada, pais, distrito, concelho, freguesia) VALUES
    ('213333333', 'Carla Mendes',    '1975-11-20', 'F', 'Rua de Santa Maria, 12',          'Portugal', 'Braga', 'Guimarães', 'Oliveira, São Paio e São Sebastião'),
    ('214444444', 'Duarte Pires',    '1988-01-30', 'M', 'Avenida D. Afonso Henriques, 140', 'Portugal', 'Braga', 'Guimarães', 'Creixomil'),
    ('222222222', 'Helena Costa',    '1995-12-01', 'F', 'Largo do Toural, 5',               'Portugal', 'Braga', 'Guimarães', 'Oliveira, São Paio e São Sebastião'),
    ('223333333', 'Tiago Fernandes', '2001-06-18', 'M', 'Rua de Azurém, 48',                'Portugal', 'Braga', 'Guimarães', 'Azurém');

INSERT INTO PessoaTelefone (NIF, telefone) VALUES
    ('213333333', '934567890'),
    ('214444444', '935678901'),
    ('222222222', '936789012'),
    ('223333333', '937890123'),
    ('223333333', '253456789');

INSERT INTO PessoaEmail (NIF, email) VALUES
    ('213333333', 'carla.mendes@nexumvitae.pt'),
    ('214444444', 'duarte.pires@nexumvitae.pt'),
    ('222222222', 'helena.costa@gmail.com'),
    ('223333333', 'tiago.fernandes@gmail.com');

-- Profissionais: médica cardiologista (RIA3) e fisioterapeuta
INSERT INTO Profissional (NIF, numProfissional, numDocIdentificacao, nomeClinico, fotografia, estado, codCategoria, codEspecialidade) VALUES
    ('213333333', 10002, '34567890', 'Dra. Carla Mendes', 'fotos/carla_mendes.jpg', 'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Médico'), (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Cardiologia')),
    ('214444444', 30001, '45678901', 'Ft. Duarte Pires',  'fotos/duarte_pires.jpg', 'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Fisioterapeuta'), NULL);

-- Carla: principal Cardiologia, também atua em Medicina Geral e Familiar (RIA4)
INSERT INTO Atuar (NIF, codEspecialidade) VALUES
    ('213333333', (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Medicina Geral e Familiar'));

INSERT INTO Vincular (NIF, localidade, tipoVinculo) VALUES
    ('213333333', 'Guimarães', 'contrato de trabalho'),
    ('214444444', 'Guimarães', 'avença');

-- Turnos dentro do horário da clínica (RIA7) e sem sobreposições (RIA8)
INSERT INTO Turno (NIF, localidade, diaSemana, horaInicio, horaFim) VALUES
    ('213333333', 'Guimarães', 'terça',   '09:00', '17:00'),
    ('213333333', 'Guimarães', 'quinta',  '09:00', '13:00'),
    ('214444444', 'Guimarães', 'segunda', '09:00', '13:00'),
    ('214444444', 'Guimarães', 'quarta',  '14:00', '18:00');

-- Utentes (o contacto de emergência não é o próprio utente - RIA2)
INSERT INTO Utente (NIF, numSNS, grupoSanguineo, nomeContactoEmerg, parentContactoEmerg, telContactoEmerg, estiloVida) VALUES
    ('222222222', '100000002', 'O-', 'Rui Costa',      'pai', '965444555', 'Pratica corrida 3 vezes por semana'),
    ('223333333', '100000003', 'A-', 'Joana Fernandes', 'mãe', '966555666', 'Estudante, joga futebol ao fim de semana');

INSERT INTO UtentePrefLingCulturais (NIF, prefLingCulturais) VALUES
    ('223333333', 'Prefere ser contactado por email');

INSERT INTO UtenteAnteCirurgico (NIF, anteCirurgico) VALUES
    ('223333333', 'Amigdalectomia (2008)');

-- Histórico clínico
INSERT INTO Padecer (NIF, codICD11) VALUES
    ('223333333', 'CA23');

INSERT INTO Herdar (NIF, codICD11, grauParent) VALUES
    ('222222222', '5A11', 'mãe'),
    ('223333333', 'BA00', 'pai');

INSERT INTO Reagir (NIF, codAlergenio, reacao) VALUES
    ('222222222', (SELECT codAlergenio FROM Alergenio WHERE designacao = 'Pólen de gramíneas'), 'Rinite na primavera'),
    ('223333333', (SELECT codAlergenio FROM Alergenio WHERE designacao = 'Amendoim'), 'Edema dos lábios e falta de ar');

-- Plano de vacinação (RIA20 e RIA22)
INSERT INTO Planear (NIF, codVacina, dataPrevista) VALUES
    ('223333333', (SELECT codVacina FROM Vacina WHERE nome = 'COVID-19'), '2026-10-13'),
    ('222222222', (SELECT codVacina FROM Vacina WHERE nome = 'Gripe'), '2026-11-20');

-- Atos médicos da clínica de Guimarães (numAto 201-299)
INSERT INTO AtoMedico (numAto, dataHoraAgenda, dataHoraAtend, estado, motivo, anamnese, pressaoArterial, freqCardiaca,
                       temperatura, peso, altura, notasClinicas, planoTerapeutico, avaliacao, comentario,
                       NIFUtente, localidade, codTipoCuidado, NIFPreferido, NIFResponsavel) VALUES
    -- 201: fisioterapia da Helena com o Duarte (segunda 05/10, turno dele 09-13)
    (201, '2026-10-05 10:00', '2026-10-05 10:00', 'realizado', 'Dor lombar após esforço',
     'Dor lombar há duas semanas', '118/76', 66, 36.4, 61.00, 1.68,
     'Contratura muscular lombar', '6 sessões de fisioterapia', 'gostei', NULL,
     '222222222', 'Guimarães', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Reabilitação e Fisioterapia'),
     NULL, '214444444'),
    -- 202: consulta da Helena com a Dra. Carla, cancelada (terça 17/11)
    (202, '2026-11-17 10:00', NULL, 'cancelado', 'Dores de cabeça frequentes', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '222222222', 'Guimarães', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '213333333', NULL),
    -- 203: consulta do Tiago com a Dra. Carla (terça 13/10, turno dela 09-17)
    (203, '2026-10-13 15:00', '2026-10-13 15:10', 'realizado', 'Falta de ar ao fazer esforço',
     'Pieira e tosse noturna há um mês', '120/78', 82, 36.8, 74.50, 1.80,
     'Asma mal controlada', 'Inalador de alívio e repetir espirometria', 'adorei', 'Explicou tudo muito bem',
     '223333333', 'Guimarães', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '213333333', '213333333'),
    -- 204: fisioterapia do Tiago com o Duarte, agendada (quarta 18/11, turno dele 14-18)
    (204, '2026-11-18 15:00', NULL, 'agendado', 'Entorse do tornozelo', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '223333333', 'Guimarães', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Reabilitação e Fisioterapia'),
     '214444444', NULL);

INSERT INTO Medicamento (numAto, codMedicamento, nome, dosagem, posologia, durTratamento) VALUES
    (203, 1, 'Salbutamol', '100 mcg/dose', '2 inalações em caso de falta de ar', 30);

-- Requisição ainda pendente: sem resultado e sem anexos (RIA19)
INSERT INTO Requisicao (numAto, numRequisicao, tipoExame, data, estado, resultado) VALUES
    (203, 1, 'Espirometria', '2026-10-13', 'pendente', NULL);

INSERT INTO Diagnosticar (numAto, codICD11) VALUES
    (203, 'CA23');

INSERT INTO Executar (numAto, codProcedimento) VALUES
    (201, (SELECT codProcedimento FROM Procedimento WHERE designacao = 'Sessão de fisioterapia'));

INSERT INTO Administrar (numAto, codVacina, numDose, lote) VALUES
    (203, (SELECT codVacina FROM Vacina WHERE nome = 'COVID-19'), 1, 'CV2026-0712');   -- 1.ª dose, planeada para 13/10


--  Clinica 3 - Margarida - Funchal

-- Clínica e horário (dias úteis, das 08:00 às 17:00)
INSERT INTO Clinica (localidade, morada, latitude, longitude) VALUES
    ('Funchal', 'Rua da Carreira, 45', 32.649700, -16.910800);

INSERT INTO Horario (localidade, diaSemana, horaAbertura, horaFecho) VALUES
    ('Funchal', 'segunda', '08:00', '17:00'),
    ('Funchal', 'terça',   '08:00', '17:00'),
    ('Funchal', 'quarta',  '08:00', '17:00'),
    ('Funchal', 'quinta',  '08:00', '17:00'),
    ('Funchal', 'sexta',   '08:00', '17:00');

-- Em todos os dias do horário há consultas e acompanhamento psicológico.
INSERT INTO Disponibilizar (localidade, diaSemana, codTipoCuidado)
SELECT h.localidade, h.diaSemana, t.codTipoCuidado
FROM Horario h, TipoCuidado t
WHERE h.localidade = 'Funchal'
  AND t.designacao IN ('Consultas Médicas de Especialidade', 'Saúde Mental e Acompanhamento Psicológico');

-- Pessoas: 2 profissionais (Rui, Inês) e 2 utentes (Lara, Emma).
-- A Emma reside no Reino Unido: pela RIA1 fica sem distrito, concelho e freguesia.
-- Na Madeira não há distritos; regista-se a região autónoma no campo distrito.
INSERT INTO Pessoa (NIF, nomeCompleto, dataNascimento, genero, morada, pais, distrito, concelho, freguesia) VALUES
    ('215555555', 'Rui Miguel Freitas', '1978-09-03', 'M', 'Rua do Aljube, 18',             'Portugal',    'Madeira', 'Funchal', 'Sé'),
    ('216666666', 'Inês Gouveia',       '1986-02-17', 'F', 'Caminho do Monte, 102',         'Portugal',    'Madeira', 'Funchal', 'Monte'),
    ('224444444', 'Lara Abreu',         '2016-04-09', 'F', 'Rua de Santa Maria, 77',        'Portugal',    'Madeira', 'Funchal', 'Santa Maria Maior'),
    ('225555555', 'Emma Clarke',        '1983-11-25', 'F', '12 Station Road, Bristol BS1',  'Reino Unido', NULL,      NULL,      NULL);

INSERT INTO PessoaTelefone (NIF, telefone) VALUES
    ('215555555', '916111222'),
    ('216666666', '927222333'),
    ('224444444', '291223344'),
    ('225555555', '+447700900123');

INSERT INTO PessoaEmail (NIF, email) VALUES
    ('215555555', 'rui.freitas@nexumvitae.pt'),
    ('216666666', 'ines.gouveia@nexumvitae.pt'),
    ('225555555', 'emma.clarke@outlook.com');

-- Profissionais: médico pediatra (RIA3) e psicóloga
INSERT INTO Profissional (NIF, numProfissional, numDocIdentificacao, nomeClinico, fotografia, estado, codCategoria, codEspecialidade) VALUES
    ('215555555', 10003, '56789012', 'Dr. Rui Freitas', 'fotos/rui_freitas.jpg', 'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Médico'), (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Pediatria')),
    ('216666666', 50001, '67890123', 'Dra. Inês Gouveia', NULL, 'Ativo',
     (SELECT codCategoria FROM Categoria WHERE designacao = 'Psicólogo'), NULL);

-- Rui: principal Pediatria, também atua em Medicina Geral e Familiar (RIA4)
INSERT INTO Atuar (NIF, codEspecialidade) VALUES
    ('215555555', (SELECT codEspecialidade FROM Especialidade WHERE designacao = 'Medicina Geral e Familiar'));

INSERT INTO Vincular (NIF, localidade, tipoVinculo) VALUES
    ('215555555', 'Funchal', 'prestação de serviços'),
    ('216666666', 'Funchal', 'contrato de trabalho');

-- Turnos dentro do horário da clínica (RIA7) e sem sobreposições (RIA8)
INSERT INTO Turno (NIF, localidade, diaSemana, horaInicio, horaFim) VALUES
    ('215555555', 'Funchal', 'segunda', '08:00', '13:00'),
    ('215555555', 'Funchal', 'quinta',  '13:00', '17:00'),
    ('216666666', 'Funchal', 'terça',   '09:00', '17:00'),
    ('216666666', 'Funchal', 'sexta',   '08:00', '12:00');

-- Utentes (o contacto de emergência não é o próprio utente - RIA2)
INSERT INTO Utente (NIF, numSNS, grupoSanguineo, nomeContactoEmerg, parentContactoEmerg, telContactoEmerg, estiloVida) VALUES
    ('224444444', '100000004', 'B-',  'Sofia Abreu',  'mãe',    '962333444',     'Pratica natação 2 vezes por semana'),
    ('225555555', '100000006', 'AB+', 'James Clarke', 'marido', '+447700900456', NULL);

INSERT INTO UtentePrefLingCulturais (NIF, prefLingCulturais) VALUES
    ('225555555', 'Prefere atendimento em inglês');

INSERT INTO UtenteAnteCirurgico (NIF, anteCirurgico) VALUES
    ('225555555', 'Cesariana (2018)');

-- Histórico clínico
INSERT INTO Padecer (NIF, codICD11) VALUES
    ('224444444', 'CA23');

INSERT INTO Herdar (NIF, codICD11, grauParent) VALUES
    ('224444444', 'CA23', 'pai');

INSERT INTO Reagir (NIF, codAlergenio, reacao) VALUES
    ('225555555', (SELECT codAlergenio FROM Alergenio WHERE designacao = 'Penicilina'), 'Erupção cutânea e comichão');

-- Plano de vacinação (RIA20 e RIA22)
INSERT INTO Planear (NIF, codVacina, dataPrevista) VALUES
    ('224444444', (SELECT codVacina FROM Vacina WHERE nome = 'Gripe'),    '2026-10-19'),
    ('225555555', (SELECT codVacina FROM Vacina WHERE nome = 'COVID-19'), '2026-11-19');

-- Atos médicos da clínica do Funchal (numAto 301-399)
INSERT INTO AtoMedico (numAto, dataHoraAgenda, dataHoraAtend, estado, motivo, anamnese, pressaoArterial, freqCardiaca,
                       temperatura, peso, altura, notasClinicas, planoTerapeutico, avaliacao, comentario,
                       NIFUtente, localidade, codTipoCuidado, NIFPreferido, NIFResponsavel) VALUES
    -- 301: consulta de pediatria da Lara com o Dr. Rui (segunda 19/10, turno dele 08-13)
    (301, '2026-10-19 09:30', '2026-10-19 09:40', 'realizado', 'Crises de tosse e pieira',
     'Tosse noturna e pieira após exercício há três semanas', '100/65', 92, 37.1, 28.50, 1.32,
     'Asma com agravamento ligeiro', 'Corticoide inalado e reavaliação em 4 semanas', 'adorei', 'Muito paciente com a criança',
     '224444444', 'Funchal', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '215555555', '215555555'),
    -- 302: acompanhamento psicológico da Emma com a Dra. Inês (terça 20/10, turno dela 09-17)
    (302, '2026-10-20 10:00', '2026-10-20 10:00', 'realizado', 'Ansiedade após mudança de país',
     'Dificuldade em dormir e preocupação constante', NULL, NULL, NULL, NULL, NULL,
     'Sintomas de ansiedade ligeira', 'Sessões quinzenais de acompanhamento', 'gostei', NULL,
     '225555555', 'Funchal', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Saúde Mental e Acompanhamento Psicológico'),
     '216666666', '216666666'),
    -- 303: consulta da Emma com o Dr. Rui, adiada (quinta 19/11, turno dele 13-17)
    (303, '2026-11-19 14:00', NULL, 'adiado', 'Vacinação e consulta de rotina', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '225555555', 'Funchal', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '215555555', NULL),
    -- 304: reavaliação da Lara com o Dr. Rui, agendada (segunda 23/11, turno dele 08-13)
    (304, '2026-11-23 10:00', NULL, 'agendado', 'Reavaliação da asma', NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
     '224444444', 'Funchal', (SELECT codTipoCuidado FROM TipoCuidado WHERE designacao = 'Consultas Médicas de Especialidade'),
     '215555555', NULL);

INSERT INTO Medicamento (numAto, codMedicamento, nome, dosagem, posologia, durTratamento) VALUES
    (301, 1, 'Budesonida', '100 mcg/dose', '1 inalação de manhã e à noite', 60);

INSERT INTO Requisicao (numAto, numRequisicao, tipoExame, data, estado, resultado) VALUES
    (301, 1, 'Radiografia do tórax', '2026-10-19', 'realizada', 'Sem alterações pleuropulmonares');

-- Anexos só em requisições 'realizada' (RIA19).
INSERT INTO Anexo (numAto, numRequisicao, numAnexo, nomeFicheiro, tipo, ficheiro, dataUpload) VALUES
    (301, 1, 1, 'rx_torax_lara.png', 'imagem', 'anexos/2026/10/rx_torax_lara.png', '2026-10-19 12:30');

INSERT INTO Diagnosticar (numAto, codICD11) VALUES
    (301, 'CA23');

INSERT INTO Administrar (numAto, codVacina, numDose, lote) VALUES
    (301, (SELECT codVacina FROM Vacina WHERE nome = 'Gripe'), 1, 'GR2026-2210');   -- 1.ª dose, planeada para 19/10