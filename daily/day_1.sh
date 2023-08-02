#!/bin/bash
# 파라미터 검증 코드

function _Init() {
    title=Console
    _Check
}

function _Check() {
    if [[ "$1" == "" ]]; then # 1차 파라미터 검증
        _Handler "$(date "+%H:%M:%S")"
    fi
}

function _Handler() {
    echo "[$title|$1] Empty the Parameters!"
} >> day_$(date "+%m%d").log

_Init # 기초 설정