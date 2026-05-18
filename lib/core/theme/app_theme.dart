import 'package:flutter/material.dart'; // Importa os componentes de UI do Flutter Material.
import 'app_colors.dart'; // Importa a classe com as cores centralizadas do app.

class AppTheme {
  // Classe utilitaria para concentrar as configuracoes de tema.
  AppTheme._(); // Construtor privado para impedir instanciacao da classe.

  static ThemeData get light {
    // Getter que retorna o tema claro da aplicacao.
    return ThemeData(
      // Cria e devolve o objeto principal de tema do Flutter.
      scaffoldBackgroundColor:
          AppColors.background, // Define a cor de fundo padrao das telas.
      elevatedButtonTheme: ElevatedButtonThemeData(
        // Configura o estilo global dos botoes elevados.
        style: ElevatedButton.styleFrom(
          // Cria um estilo base para ElevatedButton.
          backgroundColor:
              AppColors.primary, // Cor de fundo do botao (cor primaria).
          foregroundColor:
              AppColors.onPrimary, // Cor do texto/icone sobre a cor primaria.
        ), // Fecha a configuracao de estilo do botao elevado.
      ), // Fecha o tema global de ElevatedButton.
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        // Configura o estilo global do botao flutuante.
        backgroundColor: AppColors.primary, // Cor de fundo do FAB.
        foregroundColor: AppColors.onPrimary, // Cor do icone/texto do FAB.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ), // Fecha o tema do FloatingActionButton.
      colorScheme: const ColorScheme(
        // Define a paleta oficial de cores usada pelos widgets Material.
        brightness:
            Brightness.light, // Informa que este esquema eh para modo claro.
        primary: AppColors.primary, // Cor primaria da aplicacao.
        onPrimary:
            AppColors.onPrimary, // Cor usada sobre elementos com cor primaria.
        secondary: AppColors
            .secondary, // Cor secundaria para destaques/acoes secundarias.
        surface:
            AppColors.surface, // Cor de superficies como cards e containers.
        error: AppColors.error, // Cor padrao para estados de erro.
        onSurface:
            AppColors.textPrimary, // Cor de texto/icone sobre superficies.
        onSecondary: AppColors
            .onPrimary, // Cor de texto/icone sobre elementos secundarios.
        onError:
            AppColors.onPrimary, // Cor de texto/icone sobre elementos de erro.
      ), // Fecha o ColorScheme.
    ); // Fecha e retorna o ThemeData.
  } // Fecha o getter do tema claro.
} // Fecha a classe AppTheme.
