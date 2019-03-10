(function() {
    'use strict';

    angular.module('seeawayApp').controller('LancamentoCtrl', LancamentoCtrl);

    LancamentoCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog', '$stateParams'];

    function LancamentoCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog, $stateParams) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.file = file;
        vm.back = back;

        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            //url: config.REST_URL + '/',
            scrollY: '55vh',
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
                title: 'Situação Encontrada',
                field: 'situacao',
                type: 'varchar'
            }, {
                title: 'Data',
                field: 'dataco',
                type: 'date'
            }, {
                title: 'D/C',
                field: 'dc',
                label: 'dc',
                type: 'varchar',
                align: 'center'
            }, {
                title: 'contasi',
                field: 'contasi',
                type: 'int',
                visible: false
            }, {
                title: 'contaco',
                field: 'contaco',
                type: 'int',
                visible: false
            }, {
                title: 'Conta SICLID / COSIF',
                field: 'conta',
                type: 'int',
                label: 'conta'
            }, {
                title: 'Valor',
                field: 'valor',
                label: 'valor',
                type: 'float',
                numeral: '0,0.00'
            }, {
                title: 'Status',
                field: 'status',
                type: 'varchar',
                align: 'center'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {
            if (event.item.label === 'conta') {
                event.data.conta = '<table><tr><td>' + event.data.contasi + '</td>' +
                    '<tr><td>' + event.data.contaco + '</td></table>';
            } else if (event.item.label === 'dc') {
                event.data.dc = '<b style="color: red">D</b>' +
                    '<br /><b style="color: blue">C</b>';
            } else if (event.item.label === 'valor') {
                event.data.valor = '<span class="debito">' + event.data.valor + '</span>' +
                    '<br /><span class="credito">' + event.data.valor + '</span>';
            }
            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick.value, event.itemClick.pxDataGridRowNumber);
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
            vm.dgExemploControl.clearData();

            //console.info('$stateParams', $stateParams.selectedItems);

            if ($stateParams.selectedItems) {
                for (var i = 0; i <= $stateParams.selectedItems.length - 1; i++) {
                    $stateParams.selectedItems[i].dc = 'D';
                    vm.dgExemploControl.addDataRow($stateParams.selectedItems[i]);
                }
            } else {
                // fake
                vm.selectedItems = [{
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120204,
                    'contaco': 161200013004,
                    'situacao': 'Valores dos lançamentos debitados/creditados diferem dos valores de origem',
                    'medida': 'Corrigir a diferença do valor encontrado na origem',
                    'valor': 34.36
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120206,
                    'contaco': 161200013006,
                    'situacao': 'Inversão de contas contábeis',
                    'medida': 'Fazer o estorno e lançamento na conta correta',
                    'valor': 6524.82
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120214,
                    'contaco': 161200013014,
                    'situacao': 'Lançamento em conta não cadastrada',
                    'medida': 'Cadastrar nova conta para lançamento',
                    'valor': 32.31
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120218,
                    'contaco': 161200013018,
                    'situacao': 'Duplicidade de lançamentos',
                    'medida': 'Estornar lançamento duplicado',
                    'valor': 492.52
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120221,
                    'contaco': 161200013021,
                    'situacao': 'Omissão de lançamento',
                    'medida': 'Fazer lançamento omitidos',
                    'valor': 5.97
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120226,
                    'contaco': 161200013026,
                    'situacao': 'Conta contábil inexistente',
                    'medida': 'Acertar conta contábil para lancamento',
                    'valor': 76.8
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120238,
                    'contaco': 161200013038,
                    'situacao': 'Controle da conta contábil não confere',
                    'medida': 'Acertar controle da conta contábil para Lançamento',
                    'valor': 29.85
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120300,
                    'contaco': 161200013300,
                    'situacao': 'Inversão de contas contábeis',
                    'medida': 'Fazer o estorno e lançamento na conta correta',
                    'valor': 1758.02
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120301,
                    'contaco': 161200013301,
                    'situacao': 'Lançamento em conta não cadastrada',
                    'medida': 'Cadastrar nova conta para lançamento',
                    'valor': 152.25
                }, {
                    'dataco': moment().format('DD/MM/YYYY'),
                    'contasi': 203120302,
                    'contaco': 161200013302,
                    'situacao': 'Duplicidade de lançamentos',
                    'medida': 'Estornar lançamento duplicado',
                    'valor': 421.58
                }];

                const STATUS = [{
                    name: 'APROVADO',
                    color: 'darkblue'
                }, {
                    name: 'REPROVADO',
                    color: 'darkred'
                }];

                for (var j = 0; j <= vm.selectedItems.length - 1; j++) {

                    /*var r = Math.floor((Math.random() * 2));

                    vm.selectedItems[j].dc = 'D';
                    vm.selectedItems[j].status = '<b style=color:' + STATUS[r].color + ';>' + STATUS[r].name + '</b>';
                    vm.dgExemploControl.addDataRow(vm.selectedItems[j]);*/

                    vm.selectedItems[j].statusId = 0;
                    vm.selectedItems[j].status = '<b style=color:darkorange;>PENDENTE</b>';
                }
                vm.dgExemploControl.addDataRows(vm.selectedItems);
                //$state.go('situacao-medida');
            }

            //vm.dgExemploControl.getData(vm.filter);
        }

        function create() {
            $state.go('lancamento-form');
        }

        function update(id, index) {

            //$state.go('lancamento-form', { id: id });

            vm.id = id;

            $mdDialog.show({
                scope: $scope,
                preserveScope: true,
                controller: DialogController,
                controllerAs: vm,
                templateUrl: 'contabil/partial/lancamento/lancamento-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: false
            });

            DialogController.$inject = ['$scope', '$mdDialog', '$state'];

            function DialogController($scope, $mdDialog, $state) {
                console.info('$scope', $scope.vm);

                vm.title = 'Aprovar ou reprovar lancamento';
                vm.changeStatus = true;
                vm.example = $scope.vm.id;
                vm.example.valor = numeral(vm.example.valor).format('0,0.00');
                vm.example.valorFake = numeral(vm.example.valor).format('0,0.00');
                if (vm.example.statusId === 1) {
                    vm.example.statusLabel = 'Aprovado';
                } else if (vm.example.statusId === 2) {
                    vm.example.statusLabel = 'Reprovado';
                } else {
                    vm.example.statusLabel = 'Pendente';
                }

                vm.hide = hide;
                vm.cancel = cancel;
                vm.save = save;
                vm.reprovar = reprovar;
                vm.aprovar = aprovar;

                function hide() {
                    $mdDialog.hide();
                }

                function cancel() {
                    $mdDialog.cancel();
                }

                function save(data) {
                    $mdDialog.hide();
                }

                function reprovar() {
                    $mdDialog.hide();
                    vm.dgExemploControl.clearData();
                    $scope.vm.selectedItems[index].status = '<b style=color:darkred;>REPROVADO</b>';
                    $scope.vm.selectedItems[index].statusId = 2;
                    vm.dgExemploControl.addDataRows($scope.vm.selectedItems);
                }

                function aprovar() {
                    $mdDialog.hide();
                    vm.dgExemploControl.clearData();
                    $scope.vm.selectedItems[index].statusId = 1;
                    $scope.vm.selectedItems[index].status = '<b style=color:darkblue;>APROVADO</b>';
                    vm.dgExemploControl.addDataRows($scope.vm.selectedItems);
                }
            }
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

        function file() {
            $mdDialog.show(
                $mdDialog.alert({
                    onRemoving: function(element, removePromise) {
                        $state.go('home');
                    }
                })
                .clickOutsideToClose(false)
                .title('Aviso')
                .textContent('Arquivo gerado com sucesso!')
                .ok('Ok, fechar')
            );
        }

        function back() {
            $state.go('situacao-medida');
        }
    }
})();