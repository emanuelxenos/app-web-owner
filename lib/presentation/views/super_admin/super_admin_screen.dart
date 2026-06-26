import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

class SuperAdminScreen extends ConsumerStatefulWidget {
  const SuperAdminScreen({super.key});

  @override
  ConsumerState<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends ConsumerState<SuperAdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<dynamic> _users = [];
  int _userPage = 1;
  int _userTotalPages = 1;
  String _userSearch = '';
  Timer? _userDebounce;

  List<dynamic> _stores = [];
  int _storePage = 1;
  int _storeTotalPages = 1;
  String _storeSearch = '';
  Timer? _storeDebounce;

  bool _isLoadingUsers = false;
  bool _isLoadingStores = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) _loadUsers();
        else _loadStores();
      }
    });
    _loadUsers();
    _loadStores();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userDebounce?.cancel();
    _storeDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoadingUsers = true);
    try {
      final res = await ref.read(apiServiceProvider).get('/api/admin/users?page=$_userPage&limit=10&search=$_userSearch');
      if (res.data != null && res.data is Map) {
        setState(() {
          _users = res.data['data'] ?? [];
          _userTotalPages = res.data['total_pages'] ?? 1;
        });
      } else if (res.data != null && res.data is List) {
         // Fallback if backend wasn't restarted
         setState(() {
           _users = res.data;
           _userTotalPages = 1;
         });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar donos: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoadingUsers = false);
    }
  }

  Future<void> _loadStores() async {
    setState(() => _isLoadingStores = true);
    try {
      final res = await ref.read(apiServiceProvider).get('/api/admin/stores?page=$_storePage&limit=10&search=$_storeSearch');
      if (res.data != null && res.data is Map) {
        setState(() {
          _stores = res.data['data'] ?? [];
          _storeTotalPages = res.data['total_pages'] ?? 1;
        });
      } else if (res.data != null && res.data is List) {
         // Fallback if backend wasn't restarted
         setState(() {
           _stores = res.data;
           _storeTotalPages = 1;
         });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar lojas: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoadingStores = false);
    }
  }

  void _onUserSearchChanged(String query) {
    if (_userDebounce?.isActive ?? false) _userDebounce!.cancel();
    _userDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _userSearch = query;
        _userPage = 1;
      });
      _loadUsers();
    });
  }

  void _onStoreSearchChanged(String query) {
    if (_storeDebounce?.isActive ?? false) _storeDebounce!.cancel();
    _storeDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _storeSearch = query;
        _storePage = 1;
      });
      _loadStores();
    });
  }

  void _showAddUserDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Novo Dono (Cliente)', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'E-mail do Dono'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Senha Inicial'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(apiServiceProvider).post('/api/admin/users', data: {
                  'email': emailCtrl.text,
                  'password': passCtrl.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  _loadUsers();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: ${ApiService.extractError(e)}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Criar Dono'),
          ),
        ],
      ),
    );
  }

  void _showAddStoreDialog() {
    final cnpjCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Nova Loja (CNPJ)', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cnpjCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'CNPJ (Somente Números)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Nome da Loja'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(apiServiceProvider).post('/api/admin/stores', data: {
                  'cnpj': cnpjCtrl.text,
                  'name': nameCtrl.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  _loadStores();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: ${ApiService.extractError(e)}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Criar Loja'),
          ),
        ],
      ),
    );
  }

  void _showUpdateCredentialsDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Alterar Meus Dados de Acesso', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Novo E-mail (Super Admin)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Nova Senha'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(apiServiceProvider).put('/api/admin/credentials', data: {
                  'new_email': emailCtrl.text,
                  'new_password': passCtrl.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciais alteradas com sucesso!'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: ${ApiService.extractError(e)}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }

  void _showLinkDialog() {
    String? selectedEmail;
    String? selectedCnpj;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E2C),
            title: const Text('Vincular Loja ao Dono', style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownMenu<String>(
                    width: 350,
                    enableFilter: true,
                    label: const Text('Selecione o Dono (Pesquisar...)', style: TextStyle(color: Colors.white70)),
                    textStyle: const TextStyle(color: Colors.white),
                    dropdownMenuEntries: _users.map((u) => DropdownMenuEntry<String>(
                      value: u['email'] as String,
                      label: u['email'] as String,
                    )).toList(),
                    onSelected: (v) => setDialogState(() => selectedEmail = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownMenu<String>(
                    width: 350,
                    enableFilter: true,
                    label: const Text('Selecione a Loja (Pesquisar...)', style: TextStyle(color: Colors.white70)),
                    textStyle: const TextStyle(color: Colors.white),
                    dropdownMenuEntries: _stores.map((s) => DropdownMenuEntry<String>(
                      value: s['cnpj'] as String,
                      label: '${s['name']} (${s['cnpj']})',
                    )).toList(),
                    onSelected: (v) => setDialogState(() => selectedCnpj = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: (selectedEmail == null || selectedCnpj == null) ? null : () async {
                  try {
                    await ref.read(apiServiceProvider).post('/api/admin/link', data: {
                      'user_email': selectedEmail,
                      'cnpj': selectedCnpj,
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vinculado com sucesso!'), backgroundColor: Colors.green),
                      );
                      _loadUsers();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro: ${ApiService.extractError(e)}'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: const Text('Vincular'),
              ),
            ],
          );
        }
      ),
    );
  }

  void _handleLogout() async {
    // Clear state completely
    await ref.read(authProvider.notifier).logout();
    
    // Redirect to login using GoRouter
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👑 Painel UnifyTech (Super Admin)'),
        backgroundColor: Colors.amber.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            onPressed: _showUpdateCredentialsDialog,
            tooltip: 'Alterar Meus Dados (E-mail/Senha)',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadUsers();
              _loadStores();
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _handleLogout,
            tooltip: 'Sair do Painel',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Clientes (Donos)'),
            Tab(icon: Icon(Icons.store), text: 'Lojas (CNPJs)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba Clientes
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Clientes Cadastrados', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: TextField(
                            onChanged: _onUserSearchChanged,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Pesquisar e-mail...',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              filled: true,
                              fillColor: const Color(0xFF1E1E2C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _showAddUserDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Novo Dono'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoadingUsers)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_users.isEmpty)
                  const Expanded(child: Center(child: Text('Nenhum dono encontrado', style: TextStyle(color: Colors.grey))))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        final List storesList = user['stores'] ?? [];
                        
                        return Card(
                          color: const Color(0xFF1E1E2C),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(user['email'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                          Text('Cadastrado em: ${(user['created_at'] != null && user['created_at'].toString().length >= 10) ? user['created_at'].toString().substring(0, 10) : 'Agora'}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (storesList.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Text('Lojas Vinculadas:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: storesList.map((storeName) => Chip(
                                      avatar: const Icon(Icons.store, size: 14, color: Colors.white),
                                      label: Text(storeName.toString()),
                                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.3),
                                      side: BorderSide.none,
                                    )).toList(),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // Paginação Users
                if (_userTotalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _userPage > 1 ? () {
                          setState(() => _userPage--);
                          _loadUsers();
                        } : null,
                      ),
                      Text('Página $_userPage de $_userTotalPages', style: const TextStyle(color: Colors.white70)),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _userPage < _userTotalPages ? () {
                          setState(() => _userPage++);
                          _loadUsers();
                        } : null,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Aba Lojas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lojas Cadastradas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: TextField(
                            onChanged: _onStoreSearchChanged,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Pesquisar loja/cnpj...',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              filled: true,
                              fillColor: const Color(0xFF1E1E2C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _showLinkDialog,
                          icon: const Icon(Icons.link),
                          label: const Text('Vincular'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _showAddStoreDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Nova Loja'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoadingStores)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_stores.isEmpty)
                  const Expanded(child: Center(child: Text('Nenhuma loja encontrada', style: TextStyle(color: Colors.grey))))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _stores.length,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return Card(
                          color: const Color(0xFF1E1E2C),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.store)),
                            title: Text(store['name'], style: const TextStyle(color: Colors.white)),
                            subtitle: Text('CNPJ: ${store['cnpj']}', style: const TextStyle(color: Colors.grey)),
                          ),
                        );
                      },
                    ),
                  ),
                // Paginação Lojas
                if (_storeTotalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _storePage > 1 ? () {
                          setState(() => _storePage--);
                          _loadStores();
                        } : null,
                      ),
                      Text('Página $_storePage de $_storeTotalPages', style: const TextStyle(color: Colors.white70)),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _storePage < _storeTotalPages ? () {
                          setState(() => _storePage++);
                          _loadStores();
                        } : null,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
