(function() {
    'use strict';

    angular.module('seeawayApp').controller('OcorrenciaCtrl', OcorrenciaCtrl);

    OcorrenciaCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function OcorrenciaCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            //url: config.REST_URL + '/',
            method: 'GET',
            fields: [{
                link: true,
                linkId: 'edit',
                title: '',
                class: 'fa fa-pencil',
                icon: '',
                value: '',
                align: 'center'
            }, {
                title: 'Código',
                field: 'codigo',
                type: 'int'
            }, {
                title: 'Descrição',
                field: 'descricao',
                type: 'varchar'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {

            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick.value);
            }
        }

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function getData() {
            vm.filter = vm.filter || {};

            var data = [{
                codigo: 1,
                descricao: 'Erros em registros contábeis, além de classificação/apropriação de receitas, custos e gastos em naturezas e contas contábeis indevidas'
            }, {
                codigo: 2,
                descricao: 'Lançamentos a maior, menor ou em duplicidade'
            }, {
                codigo: 3,
                descricao: 'Inversões de valores gerando erros nos montantes registrados'
            }, {
                codigo: 4,
                descricao: 'Inversão de contas contábeis'
            }, {
                codigo: 5,
                descricao: 'Lançamentos manuais indevidos'
            }, {
                codigo: 6,
                descricao: 'Duplicidade de lançamentos'
            }, {
                codigo: 7,
                descricao: 'Omissão de lançamento'
            }, {
                codigo: 8,
                descricao: 'Inexistência do registro contábil por falha de Sistemas ou mesmo falta de documentação suporte'
            }, {
                codigo: 9,
                descricao: 'Identificação de fraudes e perdas para a organização'
            }, {
                codigo: 10,
                descricao: 'Necessidade de ajustes em rubricas contábeis, sejam decorrentes de erros imputáveis ao ano em curso ou anos anteriores.'
            }, {
                codigo: 11,
                descricao: 'Lançamentos a maior de Receitas que proporciona o pagamento a maior de tributos (PIS, Cofins, IRPJ, CSSL, ICMS, IPI, e outros)'
            }, {
                codigo: 12,
                descricao: 'Lançamento em conta não cadastrada'
            }, {
                codigo: 13,
                descricao: 'Registro de receitas/despesas em período diferente da ocorrência e do ingresso/desembolso'
            }, {
                codigo: 14,
                descricao: 'Conta contábil inexistente'
            }, {
                codigo: 15,
                descricao: 'Controle da conta contábil não confere'
            }, {
                codigo: 16,
                descricao: 'Divergência de valores entre emissão do cheque e o efetivo saque do mesmo'
            }, {
                codigo: 17,
                descricao: 'Valores dos lançamentos debitados/creditados diferem dos valores de origem'
            }];

            vm.dgExemploControl.addDataRows(data);

            //vm.dgExemploControl.getData(vm.filter);
        }

        function create() {
            $state.go('ocorrencia-form');
        }

        function update(id) {
            $state.go('ocorrencia-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                exampleService.remove(vm.dgExemploControl.selectedItems)
                    .then(function success(response) {
                        console.info(response);
                        if (response.success) {
                            vm.dgExemploControl.removeRow('.selected');
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();