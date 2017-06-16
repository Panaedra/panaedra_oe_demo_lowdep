
routine-level on error undo, throw.

/****************************** Source Header ********************************\

    Description: Idetest procedure for:
      
                 panaedra/msroot/mspy/logic/c_mspython_sys_interpreter_lowdep_sub.p

      Important: This is a "lowdep" low dependency version, only to be used for  
                 tests without a real Panaedra OE platform. Will not follow latest 
                 developments and can fall over.

\******************************* $NoKeywords:  $ *****************************/

{panaedra/msroot/mspy/logic/sc_mspython_externals_lowdep_def.i &OnlyPreprocessorDefs=true}

define variable hPythonExtLib  as handle    no-undo.
define variable mError         as memptr    no-undo.
define variable iErrorLen      as int64     no-undo.
define variable clobError      as longchar  no-undo.
define variable iPyObject      as integer   no-undo init 1.
define variable cPyDesc        as character no-undo init "lowdep_idetest".
define variable clobPyCode     as longchar  no-undo init "import sys;cDataOP='Hello Panaedra Python Bridge world~\n'+repr(sys.path)".
define variable clobDataIn     as longchar  no-undo init " ". /* Minimum 1 char, for memptr size. */
define variable blobDataIn     as memptr    no-undo.
define variable iLenBlobDataIn as int64     no-undo.
define variable iOutputLen     as int64     no-undo.
define variable blobOutput     as memptr    no-undo.
define variable clobOutput     as longchar  no-undo.

assign
  session:appl-alert-boxes = true
  set-size(mError)         = {&MaxErrorLen}. /* Hardcoded safe limit in shared object / dll */

run panaedra/msroot/mspy/logic/c_mspython_sys_interpreter_lowdep_sub.p persistent set hPythonExtLib.

run QxPy_InitializeInterpreter in hPythonExtLib ({&PythonExePath}, 1000, input-output mError, output iErrorLen). /* Note: iMaxModulesIP#=100.000 in initialize (but not used yet) gives an increase of ProcessMemSize=19744KB to ProcessMemSize=20516KB. This shows it's okay to leave some margin. */

if iErrorLen > 0 then 
do:
  clobError = get-string(mError, 1, iErrorLen).
  message substitute("Error initializing Python interpreter: '&1'", clobError)
    view-as alert-box.
  quit.
end.

message "Python interpreter has started succesfully."
  view-as alert-box.

run QxPy_SetCompiledPyCode in hPythonExtLib (iPyObject, cPyDesc, clobPyCode, input-output mError, output iErrorLen).

if iErrorLen > 0 then 
do:
  clobError = get-string(mError, 1, iErrorLen).
  message substitute("Error compiling or allocating Python fragment: '&1'", clobError)
    view-as alert-box.
  quit.
end.

message substitute("Succesfully compiled and allocated Python fragment:~n~n&1", clobPyCode)
  view-as alert-box.

set-size(blobDataIn) = 0.
copy-lob clobDataIn to blobDataIn. /* Deep copy probably still needed. See non-lowdep version for future insights. */
iLenBlobDataIn = get-size(blobDataIn).

run QxPy_RunCompiledPyCodeUnbuffered in hPythonExtLib (iPyObject, iLenBlobDataIn, blobDataIn, output iOutputLen, input-output mError, output iErrorLen, output blobOutput).

if iErrorLen > 0 then
do:
  clobError = get-string(mError, 1, iErrorLen).
  message substitute("Error executing Python fragment: '&1'", clobError)
    view-as alert-box.
  quit.
end.

if iOutputLen > 0 then 
do:
  set-size(blobOutput) = iOutputLen                   /* Note: see FREF@d981b49da in non-lowdep version */.
  clobOutput = get-string(blobOutput, 1, iOutputLen). /* Note: see "set-size does not reset the data in this scenario" in non-lowdep version */
end.
else
  clobOutput = "".

message substitute("Succesfully executed Python fragment:~n~n&1~n~nOutput:~n~n&2", clobPyCode, clobOutput)
  view-as alert-box.

finally:
  if valid-handle(hPythonExtLib) then 
  do:
    run QxPy_FinalizeInterpreter in hPythonExtLib.
    message "Python interpreter has exited normally."
      view-as alert-box.
    delete procedure hPythonExtLib.
  end.
  quit.
end finally.

/* EOF */
