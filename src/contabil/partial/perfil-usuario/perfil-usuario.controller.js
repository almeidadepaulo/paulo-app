(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilUsuarioCtrl', PerfilUsuarioCtrl);

    PerfilUsuarioCtrl.$inject = ['$stateParams'];

    function PerfilUsuarioCtrl($stateParams) {

        var vm = this;
        vm.tabIndex = $stateParams.tabIndex;
        console.info('vm.tabIndex', vm.tabIndex);
    }
})();