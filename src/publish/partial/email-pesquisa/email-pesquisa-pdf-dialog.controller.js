(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPesquisaPdfDialogCtrl', EmailPesquisaPdfDialogCtrl);

    EmailPesquisaPdfDialogCtrl.$inject = ['$scope', '$mdDialog', 'locals'];

    function EmailPesquisaPdfDialogCtrl($scope, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;

        function init() {
            vm.title = locals.title;
            vm.pathPdf = locals.pathPdf;
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();