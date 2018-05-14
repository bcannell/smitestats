# Add standard CS 225 object files
OBJS += cs225/HSLAPixel.o cs225/PNG.o cs225/lodepng/lodepng.o

# Use ./.objs to store all .o file (keeping the directory clean)
OBJS_DIR = .objs

# Config
CXX = clang++
LD = clang++
WARNINGS = -pedantic -Wall -Werror -Wfatal-errors -Wextra -Wno-unused-parameter -Wno-unused-variable
CXXFLAGS = $(CS225) -std=c++1y -stdlib=libc++ -g -O0 $(WARNINGS) -MMD -MP -msse2 -c
LDFLAGS = -std=c++1y -stdlib=libc++ -lpthread
ASANFLAGS = -fsanitize=address -fno-omit-frame-pointer

#  Rules for first executable
$(EXE):
	$(LD) $^ $(LDFLAGS) -o $@

# Rule for `all`
all: $(EXE)

# Pattern rules for object files
$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)
	@mkdir -p $(OBJS_DIR)/cs225
	@mkdir -p $(OBJS_DIR)/cs225/catch
	@mkdir -p $(OBJS_DIR)/cs225/lodepng
$(OBJS_DIR)/%.o: %.cpp | $(OBJS_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(OBJS_DIR)/%.o: %.cpp | $(OBJS_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

# Rules for executables
$(TEST):
	$(LD) $^ $(LDFLAGS) -o $@

# Executable dependencies
$(EXE):  $(patsubst %.o, $(OBJS_DIR)/%.o, $(OBJS))

# Include automatically generated dependencies
-include $(OBJS_DIR)/*.d
-include $(OBJS_DIR)/cs225/*.d
-include $(OBJS_DIR)/cs225/catch/*.d
-include $(OBJS_DIR)/cs225/lodepng/*.d

clean:
	rm -rf $(EXE) $(OBJS_DIR) $(CLEAN_RM) .obj

tidy: clean
	rm -rf doc

.PHONY: all $(EXE) tidy clean
