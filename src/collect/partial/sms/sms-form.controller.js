(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsFormCtrl', SmsFormCtrl);

    SmsFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'notificacaoService', 'stringUtil'];

    function SmsFormCtrl($state, $stateParams, $mdDialog, notificacaoService, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.sms = {};
        vm.cancel = cancel;
        vm.send = send;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
            } else {
                vm.action = 'create';
            }
        }

        function filterClean(model) {
            vm.filter[model] = {};
        }

        function filterDialog(model) {

            var controller = 'SacadoDialogCtrl';
            var templateUrl = 'collect/partial/sacado/sacado-dialog.html';
            var locals = {};


            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: controller,
                controllerAs: 'vm',
                templateUrl: templateUrl,
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                vm.filter[model] = data;
                console.info('data', data);
                var celular = data.item.CB201_NR_DDD + data.item.CB201_NR_CEL;
                if (celular.length > 10) {
                    vm.sms.celular = celular;
                }
            });
        }

        function cancel() {
            $state.go('menu', { id: 'sms' });
        }

        function send() {
            var data = {
                mensagem: vm.sms.mensagem,
                data: [{
                    mensagem: {
                        CPF: stringUtil.right(vm.filter.sacado.item.CB201_NR_CPFCNPJ, 11),
                        Cartao: '',
                        CodigoCampanha: 1,
                        Conta: '',
                        //DataAdesaoPacote: new Date(),
                        //DataCancelamentoPacote: new Date(),
                        DataEnvio: new Date(),
                        DDD: vm.sms.celular.substr(0, 2),
                        //DDI: 55,
                        //Email: '',
                        Logo: '',
                        NumeroPacote: 0,
                        Org: '',
                        Telefone: vm.sms.celular.substr(2, 9),
                        TipoCliente: 1,
                        TipoDaCampanha: 1,
                        /* 1 */
                        /* 1: Titulo 2:Adicional */
                        TipoTelefone: 2 /* 2 */
                    },
                    sms: {
                        //AberturaConta: new Date(),
                        //AniversarioAdicional: new Date(),
                        //AniversarioTitular: new Date(),
                        //CodigoBarras: '',
                        CodigoSMS: 0,
                        //CodigoMoeda: '',
                        //CodigoPais: '',                    
                        //DataHora: new Date(),
                        //DiasAtraso: 0,
                        //FinalCartao:0,
                        //HoraRecebimento: new Date(),
                        //LimiteDisponivel: 0 ,
                        //LimiteTotalCartao: 0,
                        //MelhorDia: '',
                        //MotivoCancelamento: ''                
                        Nome: '',
                        //NomeEstabelecimento: '',
                        //TotalAtraso: 0,
                        //ValorAutorizado: 0,
                        //ValorFatura:0,
                        //ValorMinimo:0,
                        //VencCms: new Date()
                    }
                }]
            };

            // sendSms
            notificacaoService.sendSms(data)
                .then(function success(response) {
                    console.info('success', response);
                    vm.filter.sacado = {};
                    vm.sms = {};
                    $mdDialog.show(
                        $mdDialog.alert()
                        .clickOutsideToClose(true)
                        .title('Aviso')
                        .textContent('SMS enviado com sucesso!')
                        .ariaLabel('Aviso')
                        .ok('Fechar')
                    );
                }, function error(response) {
                    console.error('error', response);
                });

        }
    }
})();