import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/services/license_service.dart';

class LicenseBlockedScreen extends ConsumerWidget {
  const LicenseBlockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final licenseAsync = ref.watch(licenseNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Center(
        child: licenseAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Erro: $err', style: const TextStyle(color: Colors.white)),
          data: (status) {
            if (status.permitido) {
              // Should not happen, but just in case, redirect to home
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/');
              });
              return const SizedBox();
            }

            return Container(
              width: 500,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.accentRed.withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentRed.withOpacity(0.1),
                    blurRadius: 50,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded, color: AppTheme.accentRed, size: 80),
                  const SizedBox(height: 24),
                  const Text(
                    'Sistema Bloqueado',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    status.mensagem.isNotEmpty ? status.mensagem : 'Sua licença expirou ou há faturas pendentes.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                  ),
                  if (status.valor > 0) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Valor da Fatura: ', style: TextStyle(color: Colors.white70)),
                          Text(
                            'R\$ ${status.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  if (status.linkPagamento.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final isHttp = status.linkPagamento.startsWith('http');
                          if (isHttp) {
                            final url = Uri.parse(status.linkPagamento);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          } else {
                            // PIX Copia e Cola
                            Clipboard.setData(ClipboardData(text: status.linkPagamento));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Código PIX copiado para a área de transferência!')),
                            );
                          }
                        },
                        icon: Icon(status.linkPagamento.startsWith('http') ? (status.statusFatura.toLowerCase().contains('cancelad') ? Icons.open_in_new_rounded : Icons.payment_rounded) : Icons.pix_rounded),
                        label: Text(
                          status.linkPagamento.startsWith('http') 
                            ? (status.statusFatura.toLowerCase().contains('cancelad') ? 'REGULARIZAR ASSINATURA' : 'PAGAR FATURA AGORA') 
                            : 'COPIAR CÓDIGO PIX',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber),
                          SizedBox(width: 8),
                          Expanded(child: Text('Nenhum link ou código de pagamento retornado. Entre em contato com o suporte.', style: TextStyle(color: Colors.amber))),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ref.read(licenseNotifierProvider.notifier).revalidate();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Já paguei, verificar novamente'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
