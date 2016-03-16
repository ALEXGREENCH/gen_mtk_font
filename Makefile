MTK_DEFS = \
	-D "__MULTI_BIN_LOAD__" \
	-D "__EXE_DLL__" \
	-D "__RESGEN_INTERNAL_POP_FILE_REDUCE__" \
	-D "__RESGEN_INTERNAL_OFFLINE__" \
	-D "__RESGEN_INTERNAL_3D_META_RESGEN_AUTO__" \
	-D "__REGEN_INTERNAL_BATCHED__"

SHARE_DEFS_BASE = \
	-D "WIN32"\
	-D "_DEBUG"\
	-D "_WINDOWS"\
	-D "_MBCS"\
	-D "_CONSOLE"\
	-D "__UCS2_ENCODING"\
	-D "MMI_ON_WIN32"\
	-D "__RESOURCE_GEN_"\
	-D "_L4_COMMON_STRUCT_H"\
	-D "DEVELOPER_BUILD_FIRST_PASS"\
	-D "_AFXDLL"\
	-D "__MOD_SMSAL__"\
	-D "__SAT__"\
	-D "SHORTCUTS_APP"\
	-D "__POPULATE_ENGINE_"\
	-D "DEBUG_WINDOW"\
	-D "VM_SUPPORT" \
	-D "_WINERROR_H" \
	-D "_LIB"\
	-D "NO_GZIP"\
	-D "NO_ERRNO_H"\
	-D "NOBYFOUR"\
	-D "__XML_SUPPORT__"

ifndef $(COMPILER_VER)
COMPILER_VER = gcc33
endif

ifeq ($(strip $(COMPILER_VER)), gcc45)
    INC =
    SHARE_DEFS = $(SHARE_DEFS_BASE)
    TIME = %time%
    VIA = @inc.via @option.via
else
    include resgen_inc.txt
    include custom_option.txt
    INC = $(RESGEN_INC)
    SHARE_DEFS = $(SHARE_DEFS_BASE) ${CUSTOM_OPTION}
    TIME =
    VIA =
endif

ifeq ($(USES_DEBUG), YES)
    MTK_DEFS:= -D "RESGEN_DEBUG_MODE"
endif

DEFINE = $(MTK_DEFS) $(SHARE_DEFS)

OUTDIR =./debug/obj

OUTDIR_RESGEN_DEP = .\debug\resgen
OUTDIR_FONT_GEN =.\fontresgen

FONT_OBJECTS = \
    $(OUTDIR_FONT_GEN)/res_gen_font.o\
    $(OUTDIR_FONT_GEN)/bdf_operation.o\
    $(OUTDIR_FONT_GEN)/FontClass.o\
    $(OUTDIR_FONT_GEN)/Fontgen.o\
    $(OUTDIR_FONT_GEN)/FontResFile.o\
    $(OUTDIR_FONT_GEN)/FontHWCompress.o

LIB = ./libbfenc.a ./libforfont.a ./LzmaLib.a

CC = gcc

CFLAG = -g

.SUFFIXES: .o .cpp .c

$(OUTDIR_FONT_GEN)/%.o: %.cpp
	@echo Compiling $< &
	@$(CC) $(DEFINE) $(INC) $(VIA) $(CFLAG) -c -w $< -MMD -MF $(OUTDIR_RESGEN_DEP)/$(basename $(@F)).d -o $@

VPATH=./zlib:./FontResgen

# Standalone offline tool has not been support in Resgen 1.5
# offline_resgen target only build the unit test progarm now
font_gen.exe: $(FONT_OBJECTS)
	@echo Linking $< &
	@echo $@: $(LIB) >$(OUTDIR_RESGEN_DEP)/$(basename $(@F)).d
	@g++ -g -o font_gen.exe $(FONT_OBJECTS) $(LIB)

clean:
	del $(OUTDIR_FONT_GEN)\*.o >nul
	if exist $(OUTDIR_RESGEN_DEP) rd /S/Q $(OUTDIR_RESGEN_DEP) >nul
	md $(OUTDIR_RESGEN_DEP)

