(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailMensagemFormCtrl', EmailMensagemFormCtrl);

    EmailMensagemFormCtrl.$inject = ['config', '$state', '$stateParams', '$mdDialog', 'emailMensagemService', 'getData',
        'emailVariavelService', '$scope', 'ngQuillConfig', '$timeout'
    ];

    function EmailMensagemFormCtrl(config, $state, $stateParams, $mdDialog,
        emailMensagemService, getData, emailVariavelService, $scope, ngQuillConfig, $timeout) {

        var vm = this;
        vm.init = init;
        vm.mensagem = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.codigoDialog = codigoDialog;
        vm.getVariavelEmail = getVariavelEmail;
        vm.initFlow = initFlow;
        vm.setFlowOptions = setFlowOptions;
        vm.getProgress = getProgress;
        vm.fileAdded = fileAdded;
        vm.fileSuccess = fileSuccess;

        vm.variaveis = [{
            EM060_DS_VAR: 'Preencha o campo Grupo e Cedente para carregar as variáveis',
            needLoad: true
        }];

        // Quantidade de caracteres disponíveis para a mensagem
        vm.mensagem.MENSAGEM_MAX_LENGTH = 140;

        // Quantidade de caracteres disponíveis para a mensagem
        $scope.MENSAGEM_MAX_LENGTH = 140;

        // Armazena varáveis disponíveis
        $scope.variaveis = [];

        // Array das varáveis que serão substituídas para cálculo caracteres
        $scope.variaveisReplace = [];

        // Map variáveis
        $scope.variaveisMap = {};

        function init() {
            getVariavelEmail();
            if ($stateParams.id) {
                vm.action = 'update';
                vm.type = 'simples';
                $timeout(function() {
                    vm.getData.EM061_CD_CODEMAIL = parseInt(vm.getData.EM061_CD_CODEMAIL);
                    vm.mensagem = vm.getData;
                }, 2000);
            } else {
                vm.type = 'simples';
                vm.action = 'create';
                vm.mensagem.EM061_ID_STATUS = 0;
                vm.mensagem.EM061_QT_CARACT = 0;
            }
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailMensagemService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-mensagem');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('email-mensagem');
        }

        function save() {

            // fix aprovador permissao
            vm.mensagem.EM061_ID_ATIVO = (vm.mensagem.EM061_ID_STATUS === 1) ? 1 : 2;
            //vm.mensagem.EM061_DS_TEXTO = $scope.mensagem;

            if ($stateParams.id) {
                //update
                emailMensagemService.update($stateParams.id, vm.mensagem)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-mensagem');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                emailMensagemService.create(vm.mensagem)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('email-mensagem');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function codigoDialog() {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'EmailCodigoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/email-codigo/email-codigo-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(data);
                vm.mensagem.EM061_CD_CODEMAIL = data.EM055_CD_CODEMAIL;
                vm.mensagem.EM055_DS_CODEMAIL = data.EM055_DS_CODEMAIL;
            });
        }

        //
        function getVariavelEmail() {
            vm.filter = vm.filter || {};
            vm.filter.page = 1;
            vm.filter.limit = 100; // fix!

            vm.variaveisMap = {};

            emailVariavelService.get(vm.filter)
                .then(function success(response) {
                    if (angular.isDefined(vm.mensagem.EM061_DS_TEXTO) && (vm.mensagem.formAction === 'update' || vm.variaveis[0].needLoad)) {
                        document.getElementById('mensagem').innerText = vm.mensagem.EM061_DS_TEXTO;
                    }

                    if (response.query.length > 0) {
                        vm.variaveis = response.query;

                        vm.variaveisReplace = vm.variaveis.map(function(value, index) {
                            // Criar chave para Map, susbstituir \ por ''
                            // Ex.: \nome\ -> nome
                            var key = value.EM060_CD_VAR.replace(new RegExp('\\\\', 'g'), '');
                            vm.variaveisMap[key] = {
                                length: value.EM060_QT_CARAC
                            };
                            return '\\' + value.EM060_CD_VAR + '\\';
                        });
                    }

                    if (angular.isDefined(vm.mensagem.EM061_DS_TEXTO) && (vm.action = 'update' || $scope.variaveis[0].needLoad === true)) {
                        document.getElementById('mensagem').innerText = vm.mensagem.EM061_DS_TEXTO;
                    }

                    if (response.query.length > 0) {
                        $scope.variaveis = response.query;

                        $scope.variaveisReplace = $scope.variaveis.map(function(value, index) {
                            // Criar chave para Map, susbstituir \ por ''
                            // Ex.: \nome\ -> nome
                            var key = value.EM060_CD_VAR.replace(new RegExp('\\\\', 'g'), '');
                            $scope.variaveisMap[key] = {
                                length: value.EM060_QT_CARAC
                            };
                            return '\\' + value.EM060_CD_VAR + '\\';
                        });
                    }
                }, function error(response) {
                    console.error('error', response);
                });
        }

        // mensagem fix $scope->vm

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

        // Inicializar ng-flow : https://github.com/flowjs/ng-flow
        function initFlow() {
            return {
                chunkSize: 104857600, // 100mb
                target: config.REST_URL + '/publish/email/mensagem/upload',
                //target: 'http://localhost:8500/rest/seeaway-app/contabil/upload',
                query: {
                    type: 'contabil-upload'
                }
            };
        }

        console.log(config);

        function setFlowOptions($flow) {
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

                $mdDialog.show({
                    scope: $scope,
                    preserveScope: true,
                    templateUrl: 'contabil/partial/upload/upload-dialog.html',
                    parent: angular.element(document.body),
                    //targetEvent: event,
                    clickOutsideToClose: true
                });
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
            } else {
                $timeout(function() {
                    // Enviar imagem para servidor
                    // Exemplo: http://localhost:8500/seeaway/_server/email-mensagem/angularjs-logo.png
                    $flow.resume();
                }, 0);
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

            var pathname = '';
            if (window.location.host.indexOf('localhost') > -1) {
                pathname = '/' + window.location.pathname.split('/')[1];
            }
            var urlImage = window.location.origin + pathname + '/_server/publish/sms-mensagem/upload/' + $file.name;
            var urlLinkText = '<div style="text-align: center;"><span style="font-size: 12px;">Problemas para visualizar a mensagem? </span><a href="' +
                urlImage + '"><span style="font-size: 12px;">Acesse este link.</span></a></div><div><br></div>';

            if (!angular.isDefined(vm.mensagem.EM061_DS_TEXTO)) {
                vm.mensagem.EM061_DS_TEXTO = '';
            }
            vm.mensagem.EM061_DS_TEXTO += urlLinkText + '<div><img src="' + urlImage + '"></div>';
            $file.finished = true;
        }
    }
})();