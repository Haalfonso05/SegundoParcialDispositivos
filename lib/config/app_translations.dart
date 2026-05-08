import 'app_notifiers.dart';

const _strings = {
  'es': {
    // Login
    'username': 'Usuario',
    'password': 'Contraseña',
    'login_btn': 'Iniciar sesión',
    // AppBar
    'title_products': 'Productos',
    'title_profile': 'Perfil',
    // Bottom nav
    'nav_add': 'Agregar',
    'nav_view': 'Consultar',
    // Form
    'field_title': 'Título',
    'field_type': 'Tipo (TV, Movie, OVA...)',
    'field_episodes': 'Episodios',
    'field_score': 'Score (0 - 10)',
    'field_synopsis': 'Sinopsis',
    'field_image': 'URL de imagen',
    'submit': 'Enviar',
    'title_required': 'El título es requerido',
    'added_ok': 'Producto agregado exitosamente',
    'no_desc': 'Sin sinopsis',
    'no_type': 'Desconocido',
    // List
    'retry': 'Reintentar',
    'no_products': 'No hay productos',
    // Drawer
    'drawer_products': 'Productos',
    'drawer_profile': 'Perfil',
    'logout': 'Cerrar Sesión',
    // Profile card
    'prof_name_label': 'Nombre',
    'prof_email_label': 'Correo',
    'prof_role_label': 'Rol',
    'prof_role_value': 'Cliente',
  },
  'en': {
    // Login
    'username': 'Username',
    'password': 'Password',
    'login_btn': 'Sign in',
    // AppBar
    'title_products': 'Products',
    'title_profile': 'Profile',
    // Bottom nav
    'nav_add': 'Add',
    'nav_view': 'View',
    // Form
    'field_title': 'Title',
    'field_type': 'Type (TV, Movie, OVA...)',
    'field_episodes': 'Episodes',
    'field_score': 'Score (0 - 10)',
    'field_synopsis': 'Synopsis',
    'field_image': 'Image URL',
    'submit': 'Submit',
    'title_required': 'Title is required',
    'added_ok': 'Product added successfully',
    'no_desc': 'No synopsis',
    'no_type': 'Unknown',
    // List
    'retry': 'Retry',
    'no_products': 'No products',
    // Drawer
    'drawer_products': 'Products',
    'drawer_profile': 'Profile',
    'logout': 'Sign Out',
    // Profile card
    'prof_name_label': 'Name',
    'prof_email_label': 'Email',
    'prof_role_label': 'Role',
    'prof_role_value': 'Customer',
  },
};

String tr(String key) {
  final lang = localeNotifier.value.languageCode;
  return _strings[lang]?[key] ?? _strings['es']![key] ?? key;
}
