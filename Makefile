CXX = g++ -std=c++11
CXXFLAGS = -g -Wall -Wextra -Wpedantic -Werror -O2

INC=-I./include
SRC=./src
OBJ=bin

PREFIX ?= /usr/local

# Available flags:
# DEBUG: DEBUG outputs from my code
# DEBUG_PROXY: DEBUG outputs from the request parsing
#              library
# VERBOSE: Prints some more info
DEBUG=


OBJFILES=$(addprefix $(OBJ)/, $(subst .c,.o, $(subst .cpp,.o, $(subst $(SRC)/,,$(wildcard $(SRC)/*)))))

print-%  : ; @echo $* = $($*)

.PHONY: all
all: wotop

wotop: $(OBJFILES)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(INC) -lpthread

$(OBJ):
	mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.cpp | $(OBJ)
	$(CXX) $(CXXFLAGS) $(DEBUG) -c $< -o $@ $(INC)

.PHONY: install
install: wotop
	install -Dm755 wotop $(DESTDIR)$(PREFIX)/bin/wotop

.PHONY: clean
clean:
	rm -rf $(OBJ)
	rm -f wotop
