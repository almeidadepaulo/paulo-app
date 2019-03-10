(function() {
    'use strict';

    // fake
    angular.module('seeawayApp').factory('situacaoMedidaService', situacaoMedidaService);

    situacaoMedidaService.$inject = ['config', '$soap', '$http'];

    function situacaoMedidaService(config, $soap, $http) {
        var service = {};

        service.sendSms = sendSms;
        service.sendEmail = sendEmail;

        return service;

        function sendSms(params) {
            var envelopeSms = {
                MensagensEnvioLote: {
                    MensagemEnvio: {
                        TMensagemEnvio: {
                            DadosSMS: {
                                'TotalAtraso': 0,
                                'HoraRecebimento': new Date(),
                                'LimiteDisponivel': 0,
                                'FinalCartao': 0,
                                'AberturaConta': new Date(),
                                'LimiteTotalCartao': 0,
                                'DataHora': new Date(),
                                'BarCode': '',
                                'CodigoSMS': 1,
                                'AniversarioAdicional': new Date(),
                                'ValorFatura': 0,
                                'ValorMinimo': 0,
                                'AniversarioTitular': new Date(),
                                'ValorAutorizado': 0,
                                'CodPais': '',
                                'DiasAtraso': 0,
                                'NomeEstabelecimento': '',
                                'MotivoCancelamento': '',
                                'CodMoeda': '',
                                'Nome': params.dadosSms.nome,
                                'MelhorDia': '',
                                'VencCms': new Date()
                            },
                            DadosMensagem: {
                                'Email': params.dadosMensagem.email,
                                'Telefone': params.dadosMensagem.telefone,
                                'CodigoCampanha': 1,
                                'DDD': params.dadosMensagem.ddd,
                                'NumeroPacote': 1,
                                'Org': 1,
                                'TipoCliente': 1,
                                'DataAdesaoPacote': new Date(),
                                'DataCancelamentoPacote': new Date(),
                                'Logo': 1,
                                'CPF': '',
                                'Conta': '',
                                'Cartao': '',
                                'TipoTelefone': 2,
                                'DataEnvio': new Date(),
                                'DDI': 55,
                                'TipoDaCampanha': 1,
                                'Operador': 3,
                                'Cedente': 1,
                                'Broker': 1
                            }
                        }
                    }
                }
            };
            console.log('envelopeSms', envelopeSms);
            //$soap.setCredentials('publish', 'publish2016');
            return $soap.post(config.PUBLISH_URL + '/wsPublish/sms/publish.cfc', 'fncEnviarMensagem', envelopeSms);
        }

        function sendEmail(params) {
            var envelopeEmail = {
                MensagensEnvioLote: {
                    MensagemEnvio: {
                        TMensagemEnvio: {
                            DadosEmail: {
                                'TotalAtraso': 0,
                                'HoraRecebimento': new Date(),
                                'LimiteDisponivel': 0,
                                'FinalCartao': 0,
                                'AberturaConta': new Date(),
                                'LimiteTotalCartao': 0,
                                'DataHora': new Date(),
                                'BarCode': '',
                                'CodigoEmail': 1,
                                'AniversarioAdicional': new Date(),
                                'ValorFatura': 0,
                                'ValorMinimo': 0,
                                'AniversarioTitular': new Date(),
                                'ValorAutorizado': 0,
                                'CodPais': '',
                                'DiasAtraso': 0,
                                'NomeEstabelecimento': '',
                                'MotivoCancelamento': '',
                                'CodMoeda': '',
                                'Nome': params.dadosEmail.nome,
                                'MelhorDia': '',
                                'VencCms': new Date()
                            },
                            DadosMensagem: {
                                'Email': params.dadosMensagem.email,
                                'Telefone': params.dadosMensagem.telefone,
                                'CodigoCampanha': 1,
                                'DDD': params.dadosMensagem.ddd,
                                'NumeroPacote': 1,
                                'Org': 1,
                                'TipoCliente': 1,
                                'DataAdesaoPacote': new Date(),
                                'DataCancelamentoPacote': new Date(),
                                'Logo': 1,
                                'CPF': '',
                                'Conta': '',
                                'Cartao': '',
                                'TipoTelefone': 2,
                                'DataEnvio': new Date(),
                                'DDI': 55,
                                'TipoDaCampanha': 1,
                                'Operador': 3,
                                'Cedente': 1,
                                'Broker': 1
                            }
                        }
                    }
                }
            };
            //console.log('envelopeEmail', envelopeEmail);
            //$soap.setCredentials('publish', 'publish20161');
            return $soap.post(config.PUBLISH_URL + '/wsPublish/email/publish.cfc', 'fncEnviarMensagem', envelopeEmail);
        }
    }
}());