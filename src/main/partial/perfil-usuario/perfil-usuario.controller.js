(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilUsuarioCtrl', PerfilUsuarioCtrl);

    PerfilUsuarioCtrl.$inject = ['$stateParams', '$rootScope'];

    function PerfilUsuarioCtrl($stateParams, $rootScope) {

        var vm = this;
        vm.tabIndex = $stateParams.tabIndex;
        vm.init = init;

        //console.info('vm.tabIndex', vm.tabIndex);

        function init() {

            if ($rootScope.globals.currentUser.perfilDeveloper) {
                vm.perfilUsuarioCedenteShow = true;
                vm.perfilUsuarioShow = true;
            } else if ($rootScope.globals.currentUser.perfilTipo === 1 || $rootScope.globals.currentUser.perfilTipo === 2) {
                vm.perfilUsuarioShow = true; // ?
            } else {
                vm.perfilUsuarioShow = true;
            }
        }
    }
})();