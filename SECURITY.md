# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

Se você descobrir uma vulnerabilidade de segurança neste projeto:

1. **NÃO** abra uma issue pública
2. Envie um email para: henrique.zimermann@outlook.com
3. Inclua:
   - Descrição detalhada da vulnerabilidade
   - Passos para reproduzir
   - Possível impacto
   - Sugestões de correção (se houver)

## Resposta

- Confirmarei o recebimento em até 48 horas
- Investigarei e responderei com plano de ação em até 7 dias
- Manterei você informado sobre o progresso
- Darei crédito (se desejar) quando a correção for publicada

## Práticas de Segurança

Este chart:
- Suporta External Secrets para gestão segura de credenciais
- Permite configuração de RBAC
- Suporta TLS/HTTPS via Ingress
- Segue best practices do Kubernetes

### Recomendações

1. **Nunca** commite secrets no repositório
2. Use External Secrets Operator em produção
3. Configure Network Policies apropriadas
4. Mantenha as imagens atualizadas
5. Use HTTPS/TLS para comunicação externa
6. Configure resource limits adequados
7. Use namespaces isolados

## Atualizações de Segurança

Atualizações de segurança serão:
- Documentadas no CHANGELOG.md
- Versionadas seguindo SemVer
- Comunicadas via release notes
