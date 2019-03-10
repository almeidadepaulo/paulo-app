(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailFormCtrl', EmailFormCtrl);

    EmailFormCtrl.$inject = ['config', '$rootScope', '$scope', '$state', '$mdDialog', 'ngQuillConfig',
        'notificacaoService'
    ];

    function EmailFormCtrl(config, $rootScope, $scope, $state, $mdDialog, ngQuillConfig,
        notificacaoService) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;
        vm.email = {};
        vm.send = send;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.numeral = numeral;
        vm.initFlow = initFlow;
        vm.setFlowOptions = setFlowOptions;
        vm.getProgress = getProgress;
        vm.fileAdded = fileAdded;
        vm.fileSuccess = fileSuccess;

        function init() {
            vm.type = 'simples';
        }

        // Inicializar ng-flow : https://github.com/flowjs/ng-flow
        function initFlow() {
            return {
                chunkSize: 104857600, // 100mb
                target: config.REST_URL + '/collect/email/upload',
                query: {
                    type: 'collect-upload'
                }
            };
        }

        function filterClean(model) {
            vm.filter[model] = {};
        }

        function filterDialog(model) {

            var controller = 'SacadoDialogCtrl';
            var templateUrl = 'collect/partial/sacado/sacado-dialog.html';
            var locals = {};


            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: controller,
                controllerAs: 'vm',
                templateUrl: templateUrl,
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                vm.filter[model] = data;
                vm.email.email = data.item.CB201_NM_EMAIL.trim();
            });
        }

        function cancel() {
            $state.go('menu', { id: 'sms' });
        }

        function send() {
            var data = {
                mensagem: vm.mensagem.EM061_DS_TEXTO,
                data: [{
                    mensagem: {
                        Email: vm.email.email,
                    },
                    email: {
                        CodigoSMS: 0
                    }
                }]
            };

            console.info('data', data);

            // sendEmail            
            notificacaoService.sendEmail(data)
                .then(function success(response) {
                    console.info('success', response);
                    vm.filter.sacado = {};
                    vm.email = {};
                    $mdDialog.show(
                        $mdDialog.alert()
                        .clickOutsideToClose(true)
                        .title('Aviso')
                        .textContent('E-mail enviado com sucesso!')
                        .ariaLabel('Aviso')
                        .ok('Fechar')
                    );
                }, function error(response) {
                    console.error('error', response);
                });

        }

        function setFlowOptions($flow) {
            //console.info('setFlowOptions', $flow);
            $scope.operacao = moment().format('YYYYMMDDHHmmss');
            $flow.opts.query.grupo = 1;
            $flow.opts.query.cedente = 1;
            $flow.opts.query.operacao = $scope.operacao;
            $flow.resume();
        }

        // Armazenar tranferências finalizadas independente 
        // se foram com sucesso ou não
        vm.transfersFinished = [];
        vm.removeSuccessLine = removeSuccessLine;

        function removeSuccessLine(event, index, file, transfers) {
            console.log(removeSuccessLine);
            // Armazenar index da transferência
            vm.transfersFinished.push(index);
            // Verificar se todas as tranferências foram finalizadas
            // independente se houve falhas
            if (vm.transfersFinished.length === transfers.length) {
                // Ordenar índicies das tranferências finalizadas
                vm.transfersFinished.sort(function(a, b) {
                    return b - a;
                });
                //console.info('sort', vm.transfersFinished);
                // Loop nas tranferências finalizadas
                for (var i = vm.transfersFinished.length - 1; i >= 0; i--) {
                    //console.info(transfers[i]);
                    // Verificar se a transferência do loop foi finalizad com sucesso
                    if (transfers[i]._prevProgress === 1) {
                        // Remover item com sucesso da listagem (área de transferência)
                        transfers.splice(i, 1);
                    }
                }
                // Resetar transfersFinished
                vm.transfersFinished = [];

                /*$mdDialog.show({
                    scope: $scope,
                    preserveScope: true,
                    templateUrl: 'contabil/partial/upload/upload-dialog.html',
                    parent: angular.element(document.body),
                    //targetEvent: event,
                    clickOutsideToClose: true
                });*/
            }
            /*
            console.group('removeSuccessLine');
            console.info('index', index);
            console.info('file', file);
            console.info('transfers', transfers);
            console.groupEnd();
            */
        }

        // Retornar % do progresso de upload
        function getProgress(value) {
            return parseInt(value * 100);
        }


        // Evento fileAdded
        function fileAdded($file, $event, $flow) {
            $file.finished = false;

            console.group('flow::fileAdded');
            console.info('$flow', $flow);
            console.info('$file', $file);
            console.groupEnd();


            // Verificar arquivos que serão ignorados:
            // > 100mb
            if ($file.size > 104857600) {
                event.preventDefault(); //prevent file from uploading
            }
        }

        // Evento fileSuccess 
        function fileSuccess($file, $message, $flow) {
            $file.finished = true;

            console.group('flow::fileSuccess');
            console.info('$file', $file);
            console.info('$message', $message);
            console.info('$flow', $flow);
            console.info('$scope.transfers', $scope.transfers);
            console.groupEnd();

        }

        // ng-quill - START

        //$scope.mensagem = '';

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

        // ng-quill - END
    }
})();