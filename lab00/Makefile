# Компилятор
FC = gfortran
# Параметры компилятора
FFLAGS = -Wall -fopenmp
# Каталог исходных файлов модулей
SRCDIR = ./src
# Каталог для хранения mod файлов
MODDIR = ./mod
# Каталог исполняемых файлов
BDIR = ./bin
# Каталог для тестирующих программ
TESTDIR = ./test
# Временные файлы
CLEAN = *.o *.png *.mod *.zip *.log *~ *.pdf *.dat *.csv *.out
# Получаем полные пути до исходных файлов модулей
SRC = $(wildcard $(SRCDIR)/*.f90)
# Получаем полные пути до исходных файлов тестирующих программ
TEST_SRC = $(wildcard $(TESTDIR)/*.f90)
# Имена исполняемых файлов
TEST = $(addprefix $(BDIR)/, $(notdir $(TEST_SRC:.f90=)))

all: $(TEST)

# Правило получения исполняемых файлов
$(BDIR)/%: $(TESTDIR)/%.f90
	@echo -e "Компилируется файл: \033[1;31m" $< "\033[1;37m"
	$(FC) $(FFLAGS) $< -o $@ -J $(MODDIR)/

run_test: $(TEST)
	$(BDIR)/test_quad
	$(BDIR)/test_sum
	$(BDIR)/test_sum_omp | python plot.py -f png -d imgs

.PHONY: clean
clean:
	@rm -vf $(CLEAN) $(TEST) $(CALC)
	@rm -vf $(BDIR)/*
	@rm -vf $(MODDIR)/*
	@rm -vf imgs/*

.PHONY: cleanall
cleanall: clean
	rmdir $(BDIR)
	rmdir $(MODDIR)
	rmdir imgs
