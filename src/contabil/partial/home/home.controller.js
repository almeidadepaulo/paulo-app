(function() {
    'use strict';

    angular.module('seeawayApp').controller('HomeCtrl', HomeCtrl);

    HomeCtrl.$inject = ['$rootScope', '$state', '$mdUtil', '$mdSidenav'];
    /* @ngInject */
    function HomeCtrl($rootScope, $state, $mdUtil, $mdSidenav) {
        var vm = this;
        vm.logout = logout;
        vm.toggleRight = buildToggler('right');
        vm.sideNav = {
            nome: $rootScope.globals.currentUser.nome.split(' ')[0]
        };
        vm.itemClick = itemClick;
        vm.toolbar = {
            menus: [{
                state: 'menu',
                params: { id: 'contabil' },
                name: 'Sistema contábil',
                class: ''
            }]
        };

        init();

        function init() {}

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
            $state.go(event.menu.state, event.menu.params);
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

    }
})();