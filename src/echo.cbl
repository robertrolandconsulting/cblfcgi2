       >>SOURCE FORMAT IS FREE
*>*******************************************
*> testing fastcgi from cobol
*>*******************************************
identification division.
program-id. echo.

environment division.
configuration section.
repository.
    function accept-req
    function resp-put-ln
    function all intrinsic.

input-output section.

data division.

working-storage section.

01  rc usage binary-long value 0.

01  in-handle          usage pointer.
01  out-handle         usage pointer.
01  err-handle         usage pointer.
01  fcgx-envp          usage pointer.

01  request-uri-ptr usage pointer.
01  request-uri redefines request-uri-ptr pic x(1024).

procedure division.

mainline.
    move accept-req(in-handle, out-handle, err-handle, fcgx-envp) to rc.

    perform until rc is less than zero
        call 'FCGX_GetParam'
        using
            by content 'REQUEST_URI'
            by value fcgx-envp
        returning request-uri-ptr

        move resp-put-ln("Content-type: text/plain", out-handle) to rc
        move resp-put-ln(" ", out-handle) to rc
        move resp-put-ln("hello world", out-handle) to rc

        move null to in-handle out-handle err-handle
        move accept-req(in-handle, out-handle, err-handle, fcgx-envp) to rc
    end-perform

    goback.

end program echo.

identification division.
function-id. resp-put-ln.

environment division.
configuration section.
repository.
    function all intrinsic.

input-output section.

data division.

working-storage section.

linkage section.

01 out-str pic x any length.
01 out-ptr usage pointer.
01 rc usage binary-long.

procedure division using
    by reference out-str
    by reference out-ptr
    returning rc.

    call "FCGX_FPrintF"
    using
        by value out-ptr
        by content z'%s'
        by content concatenate(trim(out-str), x'0d', x'0a', x'00')
    returning rc
    end-call.

    goback.
end function resp-put-ln.

identification division.
function-id. accept-req.

environment division.
configuration section.
repository.
    function all intrinsic.

input-output section.

data division.

working-storage section.

linkage section.

01 in-ptr usage pointer.
01 out-ptr usage pointer.
01 err-ptr usage pointer.
01 envp usage pointer.
01 rc usage binary-long.

procedure division
    using in-ptr out-ptr err-ptr envp returning rc.

    call "FCGX_Accept"
    using
        by reference in-ptr
        by reference out-ptr
        by reference err-ptr
        by reference envp
    returning rc.

    goback.
end function accept-req.
