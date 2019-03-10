(function() {
    'use strict';

    angular.module('seeawayApp').controller('SituacaoMedidaCtrl', SituacaoMedidaCtrl);

    SituacaoMedidaCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog',
        'situacaoMedidaService', '$mdToast', '$timeout'
    ];

    function SituacaoMedidaCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog,
        situacaoMedidaService, $mdToast, $timeout) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.lancamento = lancamento;
        vm.notificar = notificar;


        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            //url: config.REST_URL + '/',            
            scrollY: '60vh',
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
                title: 'Data',
                field: 'dataco',
                type: 'date',
                moment: 'DD/MM/YYYY',
                width: '50%'
            }, {
                title: 'Conta SICLID',
                field: 'contasi',
                type: 'int'
            }, {
                title: 'Conta COSIF',
                field: 'contaco',
                type: 'int'
            }, {
                title: 'Situação Encontrada',
                field: 'situacao',
                type: 'varchar'
            }, {
                title: 'Medida',
                field: 'medida',
                type: 'varchar'
            }, {
                title: 'Valor',
                field: 'valor',
                type: 'varchar',
                visible: false
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
            vm.filter.data = new Date();

            vm.dgExemploControl.clearData();

            var data = [{
                dataco: new Date(),
                contasi: 203120204,
                contaco: 161200013004,
                situacao: 'Valores dos lançamentos debitados/creditados diferem dos valores de origem',
                medida: 'Corrigir a diferença do valor encontrado na origem',
                valor: 34.36
            }, {
                dataco: new Date(),
                contasi: 203120206,
                contaco: 161200013006,
                situacao: 'Inversão de contas contábeis',
                medida: 'Fazer o estorno e lançamento na conta correta',
                valor: 6524.82
            }, {
                dataco: new Date(),
                contasi: 203120214,
                contaco: 161200013014,
                situacao: 'Lançamento em conta não cadastrada',
                medida: 'Cadastrar nova conta para lançamento',
                valor: 32.31
            }, {
                dataco: new Date(),
                contasi: 203120218,
                contaco: 161200013018,
                situacao: 'Duplicidade de lançamentos',
                medida: 'Estornar lançamento duplicado',
                valor: 492.52
            }, {
                dataco: new Date(),
                contasi: 203120221,
                contaco: 161200013021,
                situacao: 'Omissão de lançamento',
                medida: 'Fazer lançamento omitidos',
                valor: 5.97
            }, {
                dataco: new Date(),
                contasi: 203120226,
                contaco: 161200013026,
                situacao: 'Conta contábil inexistente',
                medida: 'Acertar conta contábil para lancamento',
                valor: 76.80
            }, {
                dataco: new Date(),
                contasi: 203120238,
                contaco: 161200013038,
                situacao: 'Controle da conta contábil não confere',
                medida: 'Acertar controle da conta contábil para Lançamento',
                valor: 29.85
            }, {
                dataco: new Date(),
                contasi: 203120300,
                contaco: 161200013300,
                situacao: 'Inversão de contas contábeis',
                medida: 'Fazer o estorno e lançamento na conta correta',
                valor: 1758.02
            }, {
                dataco: new Date(),
                contasi: 203120301,
                contaco: 161200013301,
                situacao: 'Lançamento em conta não cadastrada',
                medida: 'Cadastrar nova conta para lançamento',
                valor: 152.25
            }, {
                dataco: new Date(),
                contasi: 203120302,
                contaco: 161200013302,
                situacao: 'Duplicidade de lançamentos',
                medida: 'Estornar lançamento duplicado',
                valor: 421.58
            }, {
                dataco: new Date(),
                contasi: 203120303,
                contaco: 161200013303,
                situacao: 'Omissão de lançamento',
                medida: 'Fazer lançamento omitidos',
                valor: 587.56
            }, {
                dataco: new Date(),
                contasi: 203120304,
                contaco: 161200013304,
                situacao: 'Conta contábil inexistente',
                medida: 'Acertar conta contábil para lancamento',
                valor: 968.25
            }, {
                dataco: new Date(),
                contasi: 203120305,
                contaco: 161200013305,
                situacao: 'Controle da conta contábil não confere',
                medida: 'Acertar controle da conta contábil para Lançamento',
                valor: 125.65
            }];

            //vm.dgExemploControl.addDataRow(data[0]);

            vm.dgExemploControl.addDataRows(data);

            $timeout(function() {
                vm.doughnut = {
                    labels: ['Valores dos lançamentos diferem dos valores de origem',
                        'Inversão de contas contábeis',
                        'Lançamento em conta não cadastrada',
                        'Duplicidade de lançamentos',
                        'Omissão de lançamento',
                        'Conta contábil inexistente',
                        'Controle da conta contábil não confere'
                    ],
                    data: [1,
                        1,
                        2,
                        2,
                        2,
                        2,
                        2
                    ],
                    options: {
                        legend: {
                            display: true
                        },
                        tooltips: {
                            enabled: false,
                            custom: function(tooltip) {
                                var tooltipEl = $('#chartjs-tooltip');

                                if (!tooltip.body) {
                                    tooltipEl.css({
                                        opacity: 0
                                    });
                                    return;
                                }

                                //tooltipEl.removeClass('above below');
                                //tooltipEl.addClass(tooltip.yAlign);

                                var color = tooltip.labelColors[0].backgroundColor.replace('0.2', '1');
                                //var innerHtml = '<i class="fa fa-square" aria-hidden="true" style="color:' + color + ';"></i><span>' + tooltip.body[0].lines[0] + '</span>';
                                var innerHtml = '<span>' + tooltip.body[0].lines[0] + '</span>';
                                tooltipEl.html(innerHtml);
                                //console.info(tooltip);
                                tooltipEl.css({
                                    opacity: 1,
                                    left: tooltip.x + 'px',
                                    //fontFamily: tooltip._bodyFontFamily,
                                    //fontSize: tooltip.fontSize,
                                    //fontStyle: tooltip.fontStyle
                                });
                            }
                        }
                    }
                };
            }, 100);

            //vm.dgExemploControl.getData(vm.filter);
        }

        function create() {
            $state.go('situacao-medida-form');
        }

        function update(id) {

            //$state.go('situacao-medida-form', { id: id });

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

                vm.title = 'Situação/Medida';
                vm.changeStatus = false;
                vm.example = $scope.vm.id;
                vm.example.dataco = moment(vm.example.dataco).format('DD/MM/YYYY');
                vm.example.valor = numeral(vm.example.valor).format('0,0.00');
                vm.example.valorFake = numeral(vm.example.valor).format('0,0.00');
                vm.hide = hide;
                vm.cancel = cancel;
                vm.save = save;

                function hide() {
                    $mdDialog.hide();
                }

                function cancel() {
                    $mdDialog.cancel();
                }

                function save(data) {
                    $mdDialog.hide();
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

        function lancamento() {

            //$state.go('lancamento', { selectedItems: vm.dgExemploControl.selectedItems });

            var msg = '';
            if (vm.dgExemploControl.selectedItems.length === 0) {
                msg = 'Selecione ao menos um item da lista!';
            } else if (vm.dgExemploControl.selectedItems.length === 1) {
                msg = 'Lançamento gerado com sucesso!';
            } else {
                msg = 'Lançamentos gerados com sucesso!';
            }

            $mdDialog.show(
                $mdDialog.alert({
                    onRemoving: function(element, removePromise) {
                        vm.dgExemploControl.removeRow('.selected');
                    }
                })
                .clickOutsideToClose(false)
                .title('Aviso')
                .textContent(msg)
                .ok('Ok, fechar')
            );
        }

        function notificar(event) {
            $mdDialog.show({
                scope: $scope,
                preserveScope: true,
                controller: DialogController,
                controllerAs: vm,
                templateUrl: 'contabil/partial/situacao-medida/situacao-medida-notificar-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: false
            });

            DialogController.$inject = ['$scope', '$mdDialog', '$state'];

            function DialogController($scope, $mdDialog, $state) {

                vm.hide = hide;
                vm.cancel = cancel;
                vm.send = send;
                vm.example = {};

                function hide() {
                    $mdDialog.hide();
                }

                function cancel() {
                    $mdDialog.cancel();
                }

                function send(data) {
                    console.info('data', data);
                    $mdDialog.hide();

                    var ddd = data.celular.substr(0, 2);
                    var telefone = data.celular.substr(2, data.celular.length);

                    var params = {
                        dadosSms: {
                            nome: data.nome,
                        },
                        dadosEmail: {
                            nome: data.nome,
                        },
                        dadosMensagem: {
                            email: data.email,
                            ddd: ddd,
                            telefone: telefone
                        }
                    };

                    situacaoMedidaService.sendSms(params)
                        .then(function success(response) {
                            console.info('situacaoMedidaService.sendSms', response);
                        }, function error(response) {
                            console.error('situacaoMedidaService.sendSms', response);
                        });

                    situacaoMedidaService.sendEmail(params)
                        .then(function success(response) {
                            console.info('publishService.sendEmail', response);
                        }, function error(response) {
                            console.error('publishService.sendEmail', response);
                        });

                    $mdToast.show(
                        $mdToast.simple()
                        .textContent('Notificação enviada com sucesso!')
                        .position('bottom right')
                        .hideDelay(3500)
                    );
                }
            }
        }
    }
})();