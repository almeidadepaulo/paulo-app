(function() {
    'use strict';

    angular.module('seeawayApp').directive('seeawayViewHeader', seeawayViewHeader);

    seeawayViewHeader.$inject = ['$rootScope', 'config', '$state', 'cedenteService', 'homeService'];

    function seeawayViewHeader($rootScope, config, $state, cedenteService, homeService) {
        var directive = {
            restrict: 'E',
            replace: true,
            transclude: false,
            templateUrl: 'main/directive/seeaway-view-header/seeaway-view-header.html',
            scope: {
                logo: '@logo',
                menus: '=menus',
                itemClick: '&itemClick',
                toggleClick: '&toggleClick',
                cedenteClick: '&cedenteClick',
                cedenteLabel: '@cedenteLabel',
                cedenteSelected: '&cedenteSelected',
                cedenteSearchIconClick: '&cedenteSearchIconClick',
                searchText: '@searchText'
            },
            link: link
        };
        return directive;

        function link(scope, element, attrs) {

            scope.cedenteLabel = '';
            scope.nome = $rootScope.globals.currentUser.nome;

            // Perfil Admin?
            if ($rootScope.globals.currentUser.perfilTipo === 1) {
                scope.cedenteShow = false;
                scope.menuShow = false;
                scope.portal = 'Portal Operador do Sistema';
            } else {
                scope.menuShow = true;
                scope.cedenteShow = true;

                if ($rootScope.globals.currentUser.perfilTipo === 2) {
                    scope.portal = 'Portal Backoffice';
                } else if ($rootScope.globals.currentUser.perfilTipo === 3) {
                    scope.portal = 'Portal Cedente';
                }
            }

            scope.menus = JSON.parse(localStorage.getItem('menu' + config.PROJECT_ID));

            if (parseInt(localStorage.getItem('menuIndex' + config.PROJECT_ID)) > -1) {
                for (var i = 0; i <= scope.menus.length - 1; i++) {
                    if (scope.menus[i].MEN_ID === parseInt(localStorage.getItem('menuId' + config.PROJECT_ID))) {
                        scope.menus[i].class = 'selected-item';
                        scope.lastSelectedItem = i;
                        break;
                    }
                }
            } else {
                if (scope.menus) {
                    scope.menus[0].class = 'selected-item';
                    scope.lastSelectedItem = 0;
                    //$state.go(scope.menus[0].MEN_STATE, { name: String(scope.menus[0].MEN_NOME).toLocaleLowerCase() });
                } else {
                    homeService.getMenu()
                        .then(function success(response) {
                            localStorage.setItem('menu' + config.PROJECT_ID, JSON.stringify(response.query));
                            localStorage.setItem('menuId' + config.PROJECT_ID, response.query[0].MEN_ID);
                            localStorage.setItem('menuIndex' + config.PROJECT_ID, -1);

                            scope.menus = response.query;
                            scope.menus[0].class = 'selected-item';
                            scope.lastSelectedItem = 0;
                        }, function error(response) {
                            console.error(response);
                        });
                }
            }

            scope.$on('seeaway-view-header-update', function(event, args) {
                if (args.index === -1) {
                    scope.menus[scope.lastSelectedItem].class = '';
                }
            });

            scope.eventMenuClick = function(event, menu, index) {
                localStorage.setItem('menuIndex' + config.PROJECT_ID, index);
                localStorage.setItem('menuId' + config.PROJECT_ID, menu.MEN_ID);
                scope.current = '';
                if (scope.lastSelectedItem > -1) {
                    scope.menus[scope.lastSelectedItem].class = '';
                }
                scope.menus[index].class = 'selected-item';
                scope.lastSelectedItem = index;

                event.menu = menu;
                scope.itemClick({
                    event: event
                });
            };

            scope.eventToggleClick = function(event) {
                scope.toggleClick({
                    event: event
                });
            };

            scope.eventCedenteClick = function(event) {
                scope.cedenteClick({
                    event: event
                });
            };

            //scope.searchText = 'aa';
            document.querySelector('md-autocomplete#cedenteSearch').addEventListener('click', function(event) {
                // clicou no ícone
                if (event.target.id === '') {
                    scope.cedenteSearchIconClick({
                        event: {}
                    });
                }
            });

            scope.querySearch = function(text) {
                var filter = {};
                filter.page = 1;
                filter.limit = 5;
                filter.CB053_DS_EMIEMP = text;

                console.info(filter);

                return cedenteService.get(filter, false)
                    .then(function success(response) {
                        console.info('success', response);
                        return response.query;
                    }, function error(response) {
                        console.error('error', response);
                    });
            };

            scope.selectedItemChange = function(item) {
                console.info('selectedItemChange', item);
                scope.cedenteSelected({
                    event: item
                });
            };

            scope.cedenteSearchBlur = function(event) {
                console.log('cedenteSearchBlur', scope.selectedItem);

                if (!scope.selectedItem) {
                    /*scope.cedenteSelected({
                        event: JSON.parse(localStorage.getItem('cedente'))
                    });*/
                    if (JSON.parse(localStorage.getItem('cedente')).CEDENTE_ID !== -1) {
                        scope.searchText = JSON.parse(localStorage.getItem('cedente')).CB053_DS_EMIEMP;
                    }
                    /*
                    else {
                        //document.querySelector('#cedenteSearch').focus();
                        //$('#cedenteSearch').focus();
                    }
                    */
                }
            };

            /*setTimeout(function() {
                document.querySelector('#cedenteSearch').focus();
            }, 0);*/
        }
    }
})();