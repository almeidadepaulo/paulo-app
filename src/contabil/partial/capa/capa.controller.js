(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .controller('CapaCtrl', CapaCtrl);

    CapaCtrl.$inject = ['$scope', 'capaService', 'pxStringUtil'];

    function CapaCtrl($scope, capaService, pxStringUtil) {

        var vm = this;
        vm.init = init;
        vm.capaPdf = capaPdf;
        vm.pdfPath = '';

        function init() {
            vm.filter = {};
            vm.filter.data = new Date();
            capaPdf();
        }

        function capaPdf() {
            vm.loading = true;
            capaService.capaPdf(vm.filter)
                .then(function success(response) {
                    console.info(response);

                    var blob = pxStringUtil.toBinary(response.base64, 'application/pdf;base64');
                    var blobUrl = URL.createObjectURL(blob);

                    vm.pdfPath = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;


                    vm.loading = false;
                }, function error(response) {
                    vm.loading = false;
                    console.error(response);
                });
        }
    }
})();