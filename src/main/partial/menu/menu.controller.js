(function() {
    'use strict';

    angular.module('seeawayApp').controller('MenuCtrl', MenuCtrl);

    MenuCtrl.$inject = ['config', '$rootScope', '$scope', '$state', '$stateParams', '$mdDialog', 'homeService', '$timeout'];

    function MenuCtrl(config, $rootScope, $scope, $state, $stateParams, $mdDialog, homeService, $timeout) {

        //console.info('MenuCtrl $rootScope', $rootScope);

        $rootScope.menu = $rootScope.menu || {};

        var vm = this;
        vm.menus = [];
        vm.menus.menuZone0 = { zone: 0, items: [], openDefault: true };
        vm.menus.menuZone1 = { zone: 1, items: [], openDefault: true };
        vm.menus.menuZone2 = { zone: 2, items: [], openDefault: true };
        vm.menus.menuZone3 = { zone: 3, items: [], openDefault: true };
        vm.menus.menuZone4 = { zone: 4, items: [], openDefault: true };
        vm.menus.menuZone5 = { zone: 5, items: [], openDefault: true };
        vm.menus.menuZone6 = { zone: 6, items: [], openDefault: true };
        vm.menus.menuZone7 = { zone: 7, items: [], openDefault: true };
        vm.menus.menuZone8 = { zone: 8, items: [], openDefault: true };
        vm.menus.menuZone9 = { zone: 9, items: [], openDefault: true };
        vm.menus.menuZone10 = { zone: 10, items: [], openDefault: true };
        vm.menus.menuZone11 = { zone: 11, items: [], openDefault: true };

        if (localStorage.getItem('menuId' + config.PROJECT_ID)) {

            homeService.getChildren(parseInt(localStorage.getItem('menuId' + config.PROJECT_ID)))
                .then(function success(response) {
                    //console.info('getChildren', response);

                    console.info('$rootScope', $rootScope);

                    for (var i = 0; i <= response.query.length - 1; i++) {
                        var item = response.query[i];

                        if ($rootScope.menu['menuZone' + String(item.MEN_ZONE)]) {
                            vm.menus['menuZone' + String(item.MEN_ZONE)].open = $rootScope.menu['menuZone' + String(item.MEN_ZONE)].open;
                        } else {
                            $rootScope.menu['menuZone' + String(item.MEN_ZONE)] = {};
                            $rootScope.menu['menuZone' + String(item.MEN_ZONE)].open = vm.menus['menuZone' + String(item.MEN_ZONE)].openDefault;
                        }

                        vm.menus['menuZone' + String(item.MEN_ZONE)].items.push({
                            title: item.MEN_NOME,
                            notes: item.MEN_DESCRICAO,
                            state: item.MEN_STATE
                        });
                    }

                    $timeout(function() {
                        vm.menuComplete = true;
                    }, 0);
                });
        }

        vm.itemClick = function(event) {
            //event.state = 'example';
            $state.go(event.state);
        };

        vm.expand = function(menuZone) {
            menuZone.open = !menuZone.open;
            $rootScope.menu['menuZone' + String(menuZone.zone)].open = menuZone.open;
        };
    }
})();