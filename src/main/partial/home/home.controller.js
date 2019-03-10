(function() {
    'use strict';

    angular.module('seeawayApp').controller('HomeCtrl', HomeCtrl);

    HomeCtrl.$inject = ['$rootScope', '$scope', '$state', '$mdUtil', '$mdSidenav', 'cedenteService', '$mdDialog', '$timeout'];
    /* @ngInject */
    function HomeCtrl($rootScope, $scope, $state, $mdUtil, $mdSidenav, cedenteService, $mdDialog, $timeout) {
        var vm = this;
        vm.cedente = {};
        vm.settings = settings;
        vm.logout = logout;
        vm.toggleRight = buildToggler('left');
        vm.sideNav = {
            nome: $rootScope.globals.currentUser.nome.split(' ')[0]
        };
        vm.itemClick = itemClick;
        vm.cedenteDialog = cedenteDialog;
        vm.selectedItemChange = selectedItemChange;
        vm.querySearch = querySearch;
        vm.cedenteSelected = cedenteSelected;

        init();

        function init() {
            // Perfil Admin?
            if ($rootScope.globals.currentUser.perfilDeveloper) {
                vm.settingsShow = true;
                vm.cedenteShow = true;
            } else if ($rootScope.globals.currentUser.perfilTipo === 2) {
                vm.cedenteShow = true;
            } else {
                vm.cedenteShow = false;
            }

            var cedenteSelected = localStorage.getItem('cedente');

            //console.info('cedenteSelected', cedenteSelected);

            if (!cedenteSelected) {
                vm.filter = {};
                vm.filter.page = 1;
                vm.filter.limit = 1;

                cedenteService.get(vm.filter)
                    .then(function success(response) {
                            console.info('cedenteService get', response);
                            /*if (response.query.length > 0) {
                                vm.cedente.id = response.query[0].CEDENTE_ID;
                                vm.cedente.nome = response.query[0].CEDENTE_NOME;
                                localStorage.setItem('cedente', JSON.stringify(response.query[0]));
                            } else {
                                vm.cedente.id = 0;
                                vm.cedente.nome = '';
                            }*/

                            // Perfil Cedente
                            if ($rootScope.globals.currentUser.perfilTipo === 3 && response.query.length > 0) {
                                vm.cedente.id = response.query[0].CEDENTE_ID;
                                vm.cedente.nome = response.query[0].CEDENTE_NOME;
                                vm.cedenteSearchText = response.query[0].CEDENTE_NOME;
                                localStorage.setItem('cedente', JSON.stringify(response.query[0]));
                            } else {

                                vm.cedente.id = 0;
                                vm.cedente.nome = '';

                                localStorage.setItem('cedente', JSON.stringify({
                                    CB053_CD_EMIEMP: 0,
                                    CB053_DS_EMIEMP: '',
                                    CB053_NR_CPFCNPJ: '',
                                    CB053_NR_INST: 0,
                                    CEDENTE_ID: 0,
                                    CEDENTE_NOME: '',
                                    GRUPO_ID: 0,
                                    form: response.query.length === 0
                                }));
                            }

                            // Se for diferente de admin
                            if ($rootScope.globals.currentUser.perfilTipo !== 1) {
                                $state.go('menu');
                            }
                        },
                        function error(response) {
                            console.error('error', response);
                        });
            } else if (cedenteSelected !== 'undefined') {
                cedenteSelected = JSON.parse(cedenteSelected);
                vm.cedente.id = cedenteSelected.CEDENTE_ID;
                vm.cedente.nome = cedenteSelected.CEDENTE_NOME;

                vm.cedenteSearchText = cedenteSelected.CEDENTE_NOME;
                /////$state.go('menu');
            }
        }

        $scope.$on('home-cedente-update', function(event, args) {
            vm.cedente.id = args.cedente.CEDENTE_ID;
            vm.cedente.nome = args.cedente.CEDENTE_NOME;

            vm.cedenteSearchText = args.cedente.CEDENTE_NOME;
        });

        function settings() {
            $rootScope.$broadcast('seeaway-view-header-update', {
                index: -1
            });

            vm.toggleRight(event);

            $timeout(function() {
                $state.go('perfil-usuario');
            }, 500);
        }

        function logout() {
            $state.go('login');
        }

        function buildToggler(navID) {
            var debounceFn = $mdUtil.debounce(function() {
                $mdSidenav(navID)
                    .toggle()
                    .then(function() {
                        //$log.debug("toggle " + navID + " is done");
                    });
            }, 300);
            return debounceFn;
        }

        function itemClick(event) {
            $state.go(event.menu.MEN_STATE, { name: String(event.menu.MEN_NOME).toLocaleLowerCase() });
        }

        vm.simulateQuery = false;
        vm.isDisabled = false;

        // list of `state` value/display objects
        vm.states = loadAll();
        vm.querySearch = querySearch;
        vm.selectedItemChange = selectedItemChange;
        vm.searchTextChange = searchTextChange;

        /**
         * Search for states... use $timeout to simulate
         * remote dataservice call.
         */
        function querySearch(query) {
            var results = query ? vm.states.filter(createFilterFor(query)) : vm.states,
                deferred;
            return results;
        }

        function searchTextChange(text) {
            //$log.info('Text changed to ' + text);
        }

        function selectedItemChange(item) {
            //$log.info('Item changed to ' + JSON.stringify(item));            
            $rootScope.current = { state: item };
            //$rootScope.$broadcast("");
        }

        /**
         * Build `states` list of key/value pairs
         */
        function loadAll() {
            /* jshint ignore:start */
            var allStates = 'Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware,\
              Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana,\
              Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana,\
              Nebraska, Nevada, New Hampshire, New Jersey, New Mexico, New York, North Carolina,\
              North Dakota, Ohio, Oklahoma, Oregon, Pennsylvania, Rhode Island, South Carolina,\
              South Dakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, West Virginia,\
              Wisconsin, Wyoming';


            return allStates.split(/, +/g).map(function(state) {
                return {
                    value: state.toLowerCase(),
                    display: state
                };
            });
            /* jshint ignore:end */
        }

        /**
         * Create filter function for a query string
         */
        function createFilterFor(query) {
            var lowercaseQuery = angular.lowercase(query);

            return function filterFn(state) {
                return (state.value.indexOf(lowercaseQuery) === 0);
            };

        }

        function cedenteDialog() {
            console.info('cedenteDialog');

            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'CedenteDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'main/partial/cedente/cedente-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                //console.info(data);
                /*
                vm.cedente.id = data.CEDENTE_ID;
                vm.cedente.nome = data.CEDENTE_NOME;
                localStorage.setItem('cedente', JSON.stringify(data));

                $state.reload();
                */
                cedenteSelected(data);
            });
        }

        function cedenteSelected(event) {
            vm.cedente.id = event.CEDENTE_ID;
            vm.cedente.nome = event.CEDENTE_NOME;
            localStorage.setItem('cedente', JSON.stringify(event));

            $state.reload();
        }
    }
})();