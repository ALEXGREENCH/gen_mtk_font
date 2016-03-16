#include "StdAfx.h"
#include "FontgenGprot.h"

#define FONT_DATA_FILE_PATH(file_name) ".\\font\\"#file_name  /* "..\\..\\..\\vendor\\font\\MTK\\official\\project\\plutommi\\content\\FontData\\"#file_name */
#define FONT_DATA_OUTPUT_PATH       (".\\FontFile")

#ifdef LOW_COST_SUPPORT
#define __MMI_FONT_RESOURCE_SLIM__
#endif

#if (defined(__MMI_LANG_ENGLISH__) || defined(__MMI_LANG_SWAHILI__) || defined(__MMI_LANG_ZULU__) || defined(__MMI_LANG_XHOSA__))&& \
     !defined(__MMI_LANG_TURKISH__)&&!defined(__MMI_LANG_VIETNAMESE__)&&!defined(__MMI_LANG_POLISH__)&&!defined(__MMI_LANG_CZECH__)&&!defined(__MMI_LANG_NORWEGIAN__)&& \
     !defined(__MMI_LANG_FINNISH__)&&!defined(__MMI_LANG_HUNGARIAN__)&&!defined(__MMI_LANG_SLOVAK__)&&!defined(__MMI_LANG_DUTCH__)&&!defined(__MMI_LANG_SWEDISH__)&& \
     !defined(__MMI_LANG_CROATIAN__)&&!defined(__MMI_LANG_ROMANIAN__)&&!defined(__MMI_LANG_MOLDOVAN__)&&!defined(__MMI_LANG_SLOVENIAN__) && !defined(__MMI_LANG_FRENCH__) && !defined(__MMI_LANG_CA_FRENCH__) && \
     !defined (__MMI_LANG_LITHUANIAN__)&&!defined (__MMI_LANG_LATVIAN__)&&!defined (__MMI_LANG_ESTONIAN__)&&!defined(__MMI_LANG_AFRIKAANS__)&&!defined(__MMI_LANG_AZERBAIJANI__)&& \
     !defined (__MMI_LANG_HAUSA__)&&!defined(__MMI_LANG_ICELANDIC__)&&!defined(__MMI_LANG_SERBIAN__)&& !defined (__MMI_LANG_IGBO__) && !defined(__MMI_LANG_SPANISH__)
#define __MMI_FONT_LATIN_BASIC__

#elif (defined(__MMI_LANG_SPANISH__) || defined(__MMI_LANG_TURKISH__)|| defined(__MMI_LANG_POLISH__) ||defined(__MMI_LANG_CZECH__)||defined(__MMI_LANG_SWEDISH__)|| \
       defined(__MMI_LANG_CROATIAN__)||defined(__MMI_LANG_SLOVENIAN__)||defined(__MMI_LANG_NORWEGIAN__)||defined(__MMI_LANG_SLOVAK__)|| \
       defined(__MMI_LANG_DUTCH__)||defined(__MMI_LANG_HUNGARIAN__) || defined(__MMI_LANG_FRENCH__) || defined(__MMI_LANG_CA_FRENCH__) || \
       defined (__MMI_LANG_LITHUANIAN__) || defined (__MMI_LANG_LATVIAN__) || defined (__MMI_LANG_ESTONIAN__) || defined(__MMI_LANG_AFRIKAANS__))&& \
       !defined(__MMI_LANG_ROMANIAN__)&&!defined(__MMI_LANG_MOLDOVAN__)&&!defined(__MMI_LANG_VIETNAMESE__) && !defined(__MMI_LANG_FINNISH__)&&!defined (__MMI_LANG_HAUSA__)&& !defined (__MMI_LANG_IGBO__)
#define __MMI_FONT_LATIN_EXTEND_A__

#else

#define __MMI_FONT_LATIN_ALL__

#endif


int main(int argc, char* argv[])
{
    InitialFontEngine(FONT_DATA_OUTPUT_PATH);

    AddFont(
        ("English"), ("*#0044#"), ("en-US"), 
        FONT_DATA_FILE_PATH(latin_small.bdf),  // small 
        MCT_SMALL_FONT | MCT_SUBLCD_FONT, 0, 1);
    AddFont(
        ("English"), ("*#0044#"), ("en-US"),  ///media & large
        FONT_DATA_FILE_PATH(latin_medium.bdf),
        MCT_MEDIUM_FONT | MCT_LARGE_FONT, 0, 1);
    
    AddFont(
        ("English"), ("*#0044#"), ("en-US"), 
        FONT_DATA_FILE_PATH(latin_dialer.bdf),
        MCT_DIALER_FONT, 0, 0);

    AddFont(
        ("Chinesec"), ("*#0086#"), ("zh-CN"), 
        FONT_DATA_FILE_PATH(GB2312.bdf),
        MCT_SMALL_FONT | MCT_MEDIUM_FONT | MCT_LARGE_FONT | MCT_SUBLCD_FONT |MCT_DIALER_FONT , 
        0, 1);

    GenerateFontResFile();

    DeinitialFontEngine();

	return 0;
}
   // AddFont(&string("aa"), &string("bb"), &string("en-US"), MCT_ALPHA_SMALL_FONT, 0, 0, &bdf_path, 1);
	//AddFont(&string("aa"), &string("bb"), &string("en-US"), MCT_ALPHA_SMALL_FONT, 0, 0, &bdf_path, 1);
