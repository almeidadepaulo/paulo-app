(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPesquisaDetalheDialogCtrl', EmailPesquisaDetalheDialogCtrl);

    EmailPesquisaDetalheDialogCtrl.$inject = ['$scope', '$mdDialog', 'ngQuillConfig', 'locals'];

    function EmailPesquisaDetalheDialogCtrl($scope, $mdDialog, ngQuillConfig, locals) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;

        function init() {
            $scope.mensagem = locals.item.EM002_NM_TEXTO;

            $scope.showToolbar = true;
            $scope.translations = angular.extend({}, ngQuillConfig.translations, {
                font: 'Fonte',
                size: 'Tamanho',
                small: 'Pequeno',
                normal: 'Normal',
                large: 'Grande',
                huge: 'Enorme',
                bold: 'Negrito',
                italic: 'Itálico',
                underline: 'Sublinhado',
                strike: 'Tachado',
                textColor: 'Cor da fonte',
                backgroundColor: 'Cor de fundo',
                list: 'Numeração',
                bullet: 'Marcadores',
                textAlign: 'Alinhar texto',
                left: 'Esquerda',
                center: 'Centro',
                right: 'Direita',
                justify: 'Justificar',
                link: 'Link',
                image: 'Imagem',
                visitURL: 'Visitar URL',
                change: 'Alterar',
                remove: 'Remover',
                done: 'Pronto',
                cancel: 'Cancelar',
                insert: 'Inserir',
                preview: 'Visualizar'
            });
            /*
            $scope.toggle = function() {
                $scope.showToolbar = !$scope.showToolbar;
            };
            */
            // Own callback after Editor-Creation
            $scope.editorCallback = function(editor, name) {
                //console.log('createCallback', editor, name);
            };
            // Event after an editor is created --> gets the editor instance on optional the editor name if set
            $scope.$on('editorCreated', function(event, editor, name) {
                //console.log('createEvent', editor, name);
            });
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();