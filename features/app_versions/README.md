# app_versions

Feature Flutter responsável pelo gerenciamento remoto de versões do app Mentor.

Ela concentra o cadastro das releases disponíveis, a edição das URLs de loja
e a publicação da versão ativa usada como referência para atualização.

## Funcionalidades

- Listagem das versões cadastradas.
- Cadastro e edição de releases.
- Ativação e desativação da versão corrente.
- Configuração das URLs da Play Store e App Store.
- Suporte a mensagem de alerta por release.
- Estrutura preparada para atualização obrigatória.

## Estrutura

- `lib/domain/entities/app_version_release.dart`: modelo de release versionada.
- `lib/domain/entities/app_version_settings.dart`: configuração remota com URLs
  das lojas.
- `lib/domain/usecases/`: casos de uso para leitura e escrita das versões e
  configurações.
- `lib/data/data_access/`: integração com Firebase Cloud Firestore.
- `lib/presentation/`: páginas e `Bloc` da feature.
- `lib/injection.dart`: registro de repositório, casos de uso e bloc no service
  locator.

## Como usar

Registre as dependências da feature durante a inicialização da aplicação:

```dart
import 'package:app_versions/app_versions.dart';

void main() {
  appVersionsInjection();
}
```

Depois exponha as páginas da feature nas rotas do app:

```dart
routes: {
  '/app_versions': (_) => const AppVersionsPage(),
}
```

## Entidades principais

`AppVersionRelease` representa uma release salva remotamente com:

- `buildNumber`
- `title`
- `description`
- `showAlertMessage`
- `alertMessage`
- `mandatoryUpdate`
- `isActive`
- `createdAt`

`AppVersionSettings` representa as configurações compartilhadas da feature com:

- `playStoreUrl`
- `appStoreUrl`

## Observações

- A persistência usa Firebase/Firestore através das classes em
  `lib/data/data_access/`.
- O campo `mandatoryUpdate` já faz parte do modelo e da UI, mas está marcado no
  fluxo como preparação para uso futuro.
