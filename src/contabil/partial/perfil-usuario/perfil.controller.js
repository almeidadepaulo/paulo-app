(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilCtrl', PerfilCtrl);

    PerfilCtrl.$inject = ['config', 'perfilService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function PerfilCtrl(config, perfilService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgPerfilControl = {};
        vm.dgPerfilInit = dgPerfilInit;
        //vm.dgPerfilLabel = dgPerfilLabel;
        vm.itemClick = itemClick;
        vm.dgPerfilConfig = {
            url: config.REST_URL + '/contabil/perfil',
            scrollY: '40vh',
            method: 'GET',
            fields: [{
                pk: true,
                visible: false,
                title: 'ID',
                field: 'per_id',
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
                field: 'per_nome',
                type: 'string'
            }, {
                title: 'Status',
                field: 'per_ativo_label',
                type: 'bit'
            }]
        };

        function dgPerfilInit(event) {
            vm.getData();
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'edit') {
                console.info('itemClick', event);
                vm.update(event.itemClick.per_id);
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
            vm.dgPerfilControl.getData(vm.filter);
        }

        function create() {
            $state.go('perfil-form');
        }

        function update(id) {
            $state.go('perfil-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                perfilService.remove(vm.dgPerfilControl.selectedItems)
                    .then(function success(response) {
                        if (response.success) {
                            vm.dgPerfilControl.removeRow('.selected');
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