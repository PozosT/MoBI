# ══════════════════════════════════════════════════════════════
#  MoBI — Makefile de compilación
#  Uso: make build        → compila todo
#       make lecturas     → solo lecturas (.tex → PDF)
#       make presentaciones → solo presentaciones (.tex → PDF)
#       make notebooks    → solo notebooks (.ipynb → slides HTML)
#       make clean        → elimina auxiliares LaTeX
# ══════════════════════════════════════════════════════════════

PDFLATEX  = pdflatex -interaction=nonstopmode -output-directory
NBCONVERT = jupyter nbconvert --to slides --no-input \
            --SlidesExporter.reveal_scroll=True \
            --SlidesExporter.reveal_theme=white

LECT_SRC  = $(wildcard Lecturas/*.tex)
LECT_PDF  = $(patsubst Lecturas/%.tex, compiled/lecturas/%.pdf, $(LECT_SRC))

PRES_SRC  = $(wildcard Presentaciones/*.tex)
PRES_PDF  = $(patsubst Presentaciones/%.tex, compiled/presentaciones/%.pdf, $(PRES_SRC))

# Notebooks a convertir (excluye el original monolítico de CMTC)
NB_SRC = Codigos/Pensamiento_Sistemico_Simulacion.ipynb \
         Codigos/Simulacion_Monte_Carlo.ipynb \
         Codigos/LGN_TLC.ipynb \
         Codigos/Simulacion_Eventos_Discretos.ipynb \
         Codigos/CTMC_intro.ipynb \
         Codigos/CTMC_transitorio.ipynb \
         Codigos/CTMC_estacionario.ipynb \
         Codigos/Random_Walks.ipynb

NB_HTML  = $(patsubst Codigos/%.ipynb, compiled/notebooks/%.slides.html, $(NB_SRC))

# ── Targets ────────────────────────────────────────────────────

.PHONY: build lecturas presentaciones notebooks clean

build: lecturas presentaciones notebooks
	@echo ""
	@echo "✅  Compilación completa."
	@echo "    PDFs:    compiled/lecturas/  compiled/presentaciones/"
	@echo "    Slides:  compiled/notebooks/"

lecturas: $(LECT_PDF)

presentaciones: $(PRES_PDF)

notebooks: $(NB_HTML)

# ── Reglas ─────────────────────────────────────────────────────

compiled/lecturas/%.pdf: Lecturas/%.tex | compiled/lecturas
	@echo "📖  Compilando lectura: $<"
	$(PDFLATEX) compiled/lecturas $< > /dev/null 2>&1 || \
	$(PDFLATEX) compiled/lecturas $< > /dev/null 2>&1
	@echo "    → $@"

compiled/presentaciones/%.pdf: Presentaciones/%.tex | compiled/presentaciones
	@echo "📊  Compilando presentación: $<"
	$(PDFLATEX) compiled/presentaciones $< > /dev/null 2>&1 || \
	$(PDFLATEX) compiled/presentaciones $< > /dev/null 2>&1
	@echo "    → $@"

compiled/notebooks/%.slides.html: Codigos/%.ipynb | compiled/notebooks
	@echo "💻  Convirtiendo notebook: $<"
	$(NBCONVERT) --output-dir compiled/notebooks $<
	@echo "    → $@"

# ── Directorios ────────────────────────────────────────────────

compiled/lecturas compiled/presentaciones compiled/notebooks:
	mkdir -p $@

# ── Limpieza ───────────────────────────────────────────────────

clean:
	rm -f compiled/lecturas/*.aux  compiled/lecturas/*.log  \
	      compiled/lecturas/*.out  compiled/lecturas/*.toc  \
	      compiled/presentaciones/*.aux compiled/presentaciones/*.log \
	      compiled/presentaciones/*.out compiled/presentaciones/*.nav \
	      compiled/presentaciones/*.snm compiled/presentaciones/*.toc \
	      compiled/presentaciones/*.vrb
	@echo "🧹  Auxiliares eliminados."
