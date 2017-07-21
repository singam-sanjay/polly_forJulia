; The instruction marked I is copied into the GPUModule, with changes only
; to the parameters to access data on the device instead of the host, i.e.,
; MemRef_arr becomes polly.access.cast.MemRef_arr. Since the instruction is
; annotated with a DILocation, copying the instruction also copies the metadata
; into the GPUModule. This stops codegenerating the ptx_kernel by failing the 
; verification of the Module in GPUNodeBuilder::finalize, due to the 
; copied DICompileUnit not being listed in a llvm.dbg.cu which was neither
; copied nor created.

; https://reviews.llvm.org/D35630 removes this debug metadata before the
; instruction is copied to the GPUModule.

; RUN: opt %loadPolly %s -polly-process-unprofitable -polly-codegen-ppcg -polly-acc-dump-kernel-ir \
; RUN: | FileCheck --check-prefix=KERNEL-IR %s

; REQUIRES: pollyacc

; KERNEL-IR: define ptx_kernel void @FUNC_vec_add_1_SCOP_0_KERNEL_0(i8 addrspace(1)* %MemRef_arr, i32 %N) #0 {

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Function Attrs: nounwind uwtable
define void @vec_add_1(i32 %N, i32* nocapture %arr) local_unnamed_addr #0 !dbg !4 {
entry:
  %wide.trip.count = zext i32 %N to i64
  %n.vec = sub nsw i64 %wide.trip.count, 0, !dbg !7
  br label %vector.body, !dbg !7

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %entry ], !dbg !8
  %0 = getelementptr inbounds i32, i32* %arr, i64 %index, !dbg !7
  %1 = getelementptr i32, i32* %0, i64 4, !dbg !9
  %2 = add nsw <4 x i32> undef, <i32 1, i32 1, i32 1, i32 1>, !dbg !9  ; I
  %3 = bitcast i32* %1 to <4 x i32>*, !dbg !9
  store <4 x i32> %2, <4 x i32>* %3, align 4, !dbg !9, !tbaa !10
  %index.next = add i64 %index, 8, !dbg !8
  %4 = icmp eq i64 %index.next, %n.vec, !dbg !8
  br i1 %4, label %middle.block, label %vector.body, !dbg !8, !llvm.loop !14

middle.block:                                     ; preds = %vector.body
  ret void, !dbg !19
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 5.0.0 (http://llvm.org/git/clang.git 23e042ffe07a923db2dbebf4d2a3692c5a454fee) (http://llvm.org/git/llvm.git 39c5686a1f54884f12120927b1753a750fdb5e02)", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly)
!1 = !DIFile(filename: "vec_add_1.c", directory: "/home/sanjay/Programs/C/generateIR_WithDebugMetadata")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = distinct !DISubprogram(name: "vec_add_1", scope: !1, file: !1, line: 1, type: !5, isLocal: false, isDefinition: true, scopeLine: 1, flags: DIFlagPrototyped, isOptimized: true, unit: !0)
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 3, column: 25, scope: !4)
!8 = !DILocation(line: 3, column: 21, scope: !4)
!9 = !DILocation(line: 3, column: 32, scope: !4)
!10 = !{!11, !11, i64 0}
!11 = !{!"int", !12, i64 0}
!12 = !{!"omnipotent char", !13, i64 0}
!13 = !{!"Simple C/C++ TBAA"}
!14 = distinct !{!14, !15, !16, !17, !18}
!15 = !DILocation(line: 3, column: 3, scope: !4)
!16 = !DILocation(line: 3, column: 35, scope: !4)
!17 = !{!"llvm.loop.vectorize.width", i32 1}
!18 = !{!"llvm.loop.interleave.count", i32 1}
!19 = !DILocation(line: 4, column: 1, scope: !4)
