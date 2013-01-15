module us.voxg.midi.winmidi;

version (Windows) {
extern (Windows) {

// Basic Windows types
alias ushort WORD;
alias wchar TCHAR;
alias wchar WCHAR;
alias uint DWORD;

// mmsystem.h specific types, defines, and structs
alias uint MMVERSION;
alias uint MMRESULT;
const int MAXPNAMELEN = 32;

const uint MIM_OPEN      =  0x3C1;          /* MIDI input */
const uint MIM_CLOSE     =  0x3C2;
const uint MIM_DATA      =  0x3C3;
const uint MIM_LONGDATA  =  0x3C4;
const uint MIM_ERROR     =  0x3C5;
const uint MIM_LONGERROR =  0x3C6;

const uint MM_MIM_OPEN      =  0x3C1;          /* MIDI input */
const uint MM_MIM_CLOSE     =  0x3C2;
const uint MM_MIM_DATA      =  0x3C3;
const uint MM_MIM_LONGDATA  =  0x3C4;
const uint MM_MIM_ERROR     =  0x3C5;
const uint MM_MIM_LONGERROR =  0x3C6;

const uint CALLBACK_TYPEMASK = 0x00070000;    /* callback type mask */
const uint CALLBACK_NULL     = 0x00000000;   /* no callback */
const uint CALLBACK_WINDOW   = 0x00010000;   /* dwCallback is a HWND */
const uint CALLBACK_TASK     = 0x00020000;   /* dwCallback is a HTASK */
const uint CALLBACK_FUNCTION = 0x00030000;   /* dwCallback is a FARPROC */
const uint CALLBACK_THREAD   = (CALLBACK_TASK);/* thread ID replaces 16 bit task */
const uint CALLBACK_EVENT    = 0x00050000;   /* dwCallback is an EVENT Handle */

const uint MIDIERR_BASE = 64;
const uint MIDIERR_UNPREPARED    = MIDIERR_BASE + 0;   /* header not prepared */
const uint MIDIERR_STILLPLAYING  = MIDIERR_BASE + 1;   /* still something playing */
const uint MIDIERR_NOMAP         = MIDIERR_BASE + 2;   /* no configured instruments */
const uint MIDIERR_NOTREADY      = MIDIERR_BASE + 3;   /* hardware is still busy */
const uint MIDIERR_NODEVICE      = MIDIERR_BASE + 4;   /* port no longer connected */
const uint MIDIERR_INVALIDSETUP  = MIDIERR_BASE + 5;   /* invalid MIF */
const uint MIDIERR_BADOPENMODE   = MIDIERR_BASE + 6;   /* operation unsupported w/ open mode */
const uint MIDIERR_DONT_CONTINUE = MIDIERR_BASE + 7;   /* thru device 'eating' a message */
const uint MIDIERR_LASTERROR     = MIDIERR_BASE + 7;   /* last error in range */

struct MIDIINCAPS {
  WORD wMid;
  WORD wPid;
  MMVERSION vDriverVersion;
  char szPname[MAXPNAMELEN];
  DWORD dwSupport;
}
struct MIDIOUTCAPS {
  WORD    wMid;                  /* manufacturer ID */
  WORD    wPid;                  /* product ID */
  MMVERSION vDriverVersion;      /* version of the driver */
  char    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
  WORD    wTechnology;           /* type of device */
  WORD    wVoices;               /* # of voices (internal synth only) */
  WORD    wNotes;                /* max # of notes (internal synth only) */
  WORD    wChannelMask;          /* channels used (internal synth only) */
  DWORD   dwSupport;             /* functionality supported by driver */
}
alias void* HMIDIOUT;
alias void* HMIDIIN;
struct MIDIHDR {
  ubyte      *lpData;               /* pointer to locked data block */
  DWORD       dwBufferLength;       /* length of data in data block */
  DWORD       dwBytesRecorded;      /* used for input only */
  DWORD       dwUser;               /* for client's use */
  DWORD       dwFlags;              /* assorted flags (see defines) */
  MIDIHDR    *lpNext;   /* reserved for driver */
  DWORD       reserved;             /* reserved for driver */
  //#if (WINVER >= 0x0400)
  DWORD       dwOffset;             /* Callback offset into buffer */
  DWORD       dwReserved[8];        /* Reserved for MMSYSTEM */
  //#endif
}

// mmsystem.h functions
uint midiInGetNumDevs();
uint midiOutGetNumDevs();
MMRESULT midiInGetDevCapsA(
    uint uDeviceID,
    MIDIINCAPS *lpMidiInCaps,
    uint cbMidiInCaps);
MMRESULT midiOutGetDevCapsA(
    uint uDeviceID,
    MIDIOUTCAPS *lpMidiOutCaps,
    uint cbMidiOutCaps);

MMRESULT midiOutOpen(HMIDIOUT *phmo, uint uDeviceID, DWORD dwCallback,
    DWORD dwInstance, DWORD fdwOpen);
MMRESULT midiOutClose(HMIDIOUT hmo);
MMRESULT midiOutPrepareHeader(HMIDIOUT hmo, MIDIHDR *pmh, uint cbmh);
MMRESULT midiOutUnprepareHeader(HMIDIOUT hmo, MIDIHDR *pmh, uint cbmh);
MMRESULT midiOutShortMsg(HMIDIOUT hmo, DWORD dwMsg);
MMRESULT midiOutLongMsg(HMIDIOUT hmo, MIDIHDR *pmh, uint cbmh);
MMRESULT midiOutReset(HMIDIOUT hmo);
MMRESULT midiOutGetID(HMIDIOUT hmo, uint *puDeviceID);
MMRESULT midiOutGetErrorTextA(MMRESULT mmrError, char *pszText, uint cchText);


MMRESULT midiInGetErrorTextA(MMRESULT mmrError, char *pszText, uint cchText);
MMRESULT midiInOpen(HMIDIIN *phmi, uint uDeviceID,
	DWORD dwCallback, DWORD dwInstance, DWORD fdwOpen);
MMRESULT midiInClose(HMIDIIN hmi);
MMRESULT midiInPrepareHeader(HMIDIIN hmi, MIDIHDR *pmh, uint cbmh);
MMRESULT midiInUnprepareHeader(HMIDIIN hmi, MIDIHDR *pmh, uint cbmh);
MMRESULT midiInAddBuffer(HMIDIIN hmi, MIDIHDR *pmh, uint cbmh);
MMRESULT midiInStart(HMIDIIN hmi);
MMRESULT midiInStop(HMIDIIN hmi);
MMRESULT midiInReset(HMIDIIN hmi);
MMRESULT midiInGetID(HMIDIIN hmi, uint *puDeviceID);


} // extern (Windows)
} // version (Windows)
