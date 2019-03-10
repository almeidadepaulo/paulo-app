(function() {
    'use strict';

    angular.module('seeawayApp').controller('PagamentoPdfDialogCtrl', PagamentoPdfDialogCtrl);

    PagamentoPdfDialogCtrl.$inject = ['config', 'pagamentoService', '$rootScope', '$scope', '$state', '$mdDialog',
        'locals', 'stringUtil'
    ];

    function PagamentoPdfDialogCtrl(config, pagamentoService, $rootScope, $scope, $state, $mdDialog,
        locals, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.sendEmail = sendEmail;
        vm.cancel = cancel;

        function init(event) {
            vm.loading = true;
            vm.email = locals.items[0].CB201_NM_EMAIL.trim();
            getData();
        }

        function getData() {
            pagamentoService.pdf(locals)
                .then(function success(response) {
                    console.info('getBlobByProtocolo', response);

                    var blob = stringUtil.toBinary(response.base64, 'application/pdf;base64');
                    var blobUrl = URL.createObjectURL(blob);

                    vm.pathPdf = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;
                    vm.loading = false;
                }, function error(error) {
                    vm.loading = false;
                    console.error(error);
                });
        }

        function sendEmail() {
            vm.loading = true;
            locals.email = vm.email;

            pagamentoService.pdfEmail(locals)
                .then(function success(response) {
                    console.info('pdfEmail', response);
                    vm.loading = false;
                }, function error(error) {
                    vm.loading = false;
                    console.error(error);
                });
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();