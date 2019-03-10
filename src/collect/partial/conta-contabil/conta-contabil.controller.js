(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaContabilCtrl', ContaContabilCtrl);

    ContaContabilCtrl.$inject = ['config', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContaContabilCtrl(config, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.contabil = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            //pagination: pagination,
            total: 0
        };

        function init(event) {
            vm.getData();
        }

        function dgContabilLabel(event) {

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
            const TIPO = ['Patrimonial', 'Resultado'];

            const CN = [{
                classco: 'Despesa',
                naturez: 'Devedora'
            }, {
                classco: 'Receita',
                naturez: 'Credora'
            }];

            vm.contabil.data = [];
            for (var i = 0; i <= 8; i++) {

                var r = Math.floor((Math.random() * 2));

                vm.contabil.data.push({
                    'codigo': i + 161200013000,
                    'descricao': 'Nome ' + Math.floor((Math.random() * 100000) + 1),
                    'tipoco': TIPO[Math.floor((Math.random() * 2))],
                    'classco': CN[r].classco,
                    'naturez': CN[r].naturez
                });
            }
        }

        function create() {
            $state.go('conta-contabil-form');
        }

        function update(id) {
            $state.go('conta-contabil-form', { id: id });
        }

        function remove() {

        }
    }
})();