(function() {
    'use strict';

    angular.module('seeawayApp').controller('UsuarioCtrl', UsuarioCtrl);

    UsuarioCtrl.$inject = ['config', 'usuarioService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function UsuarioCtrl(config, usuarioService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgUsuarioControl = {};
        vm.dgUsuarioInit = dgUsuarioInit;
        vm.dgUsuarioLabel = dgUsuarioLabel;
        vm.itemClick = itemClick;
        vm.dgUsuarioConfig = {
            url: config.REST_URL + '/contabil/usuario',
            scrollY: '40vh',
            method: 'GET',
            fields: [{
                pk: true,
                visible: false,
                title: 'ID',
                field: 'usu_id',
                type: 'int',
                identity: true
            }, {
                link: true,
                linkId: 'edit',
                title: '',
                class: 'fa fa-pencil',
                icon: '',
                value: '',
                align: 'center'
            }, {
                title: 'Nome',
                field: 'usu_nome',
                type: 'string'
            }, {
                title: 'Login',
                field: 'usu_login',
                type: 'string'
            }, {
                title: 'CPF',
                field: 'usu_cpf',
                type: 'int',
                stringMask: '###.###.###-##'
            }, {
                title: 'Perfil',
                field: 'per_nome',
                type: 'string',
            }, {
                title: 'Status',
                field: 'usu_ativo_label',
                type: 'bit'
            }, {
                title: 'Último acesso',
                field: 'usu_ultimoAcesso',
                type: 'date',
                moment: 'DD/MM/YYYY HH:mm:ss'
            }]
        };

        function dgUsuarioInit(event) {
            vm.getData();
        }

        function dgUsuarioLabel(event) {
            if (event.item.label === 'bateria') {
                event.item.class = 'fa fa-battery-' + event.data.bateria;
            } else if (event.item.label === 'status') {
                if (event.data.status === 1) {
                    event.data.status = '<span class="label label-success">ATIVO</span>';
                } else {
                    event.data.status = '<span class="label label-warning">PENDENTE</span>';
                }
            }

            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick.usu_id);
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
            console.info(vm.filter);
            vm.dgUsuarioControl.getData(vm.filter);
        }

        function create() {
            $state.go('usuario-form');
        }

        function update(id) {
            $state.go('usuario-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                usuarioService.remove(vm.dgUsuarioControl.selectedItems)
                    .then(function success(response) {
                        if (response.success) {
                            vm.dgUsuarioControl.removeRow('.selected');
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