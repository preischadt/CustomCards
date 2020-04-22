--Murloc
function c420000042.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000042.ffilter)
    Fusion.AddContactProc(c, c420000042.contactfil, c420000042.contactop, c420000042.splimit, aux.TRUE, 1)

    --spsummon
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(17412721, 1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c420000042.spcon)
    e3:SetTarget(c420000042.sptg)
    e3:SetOperation(c420000042.spop)
    c:RegisterEffect(e3)
end
function c420000042.ffilter(c)
    return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c420000042.splimit(e, se, sp, st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000042.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000042.contactfil(tp)
    return Duel.GetMatchingGroup(c420000042.matfil, tp, LOCATION_MZONE, 0, nil, tp)
end
function c420000042.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

function c420000042.spfilter1(c, tp)
    return (c:IsCode(28297833) or c420000042.ffilter(c)) and c:IsAbleToRemoveAsCost() and
        c:IsCanBeFusionMaterial(nil, true) and
        Duel.IsExistingMatchingCard(c420000042.spfilter2, tp, LOCATION_ONFIELD, 0, 1, c, c)
end
function c420000042.spfilter2(c, c1)
    return ((c1:IsCode(28297833) and c420000042.ffilter(c)) or (c:IsCode(28297833) and c420000042.ffilter(c1))) and
        c:IsAbleToRemoveAsCost() and
        c:IsCanBeFusionMaterial(nil, true)
end
function c420000042.sprcon(e, c)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > -2 and
        Duel.IsExistingMatchingCard(c420000042.spfilter1, tp, LOCATION_ONFIELD, 0, 1, nil, tp)
end
function c420000042.sprop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(48156348, 2))
    local g1 = Duel.SelectMatchingCard(tp, c420000042.spfilter1, tp, LOCATION_ONFIELD, 0, 1, 1, nil, tp)
    Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(48156348, 3))
    local g2 =
        Duel.SelectMatchingCard(tp, c420000042.spfilter2, tp, LOCATION_ONFIELD, 0, 1, 1, g1:GetFirst(), g1:GetFirst())
    g1:Merge(g2)
    local tc = g1:GetFirst()
    while tc do
        --if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
        tc = g1:GetNext()
    end
    Duel.Remove(g1, POS_FACEUP, REASON_COST)
end

function c420000042.spcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetSummonType() == SUMMON_TYPE_SPECIAL + 1
end
function c420000042.filter(c, e, tp)
    return c:IsFaceup() and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)) and
        c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c420000042.filter2(c, e, tp)
    return c:IsFaceup() and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c420000042.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_REMOVED) and c420000042.filter(chkc, e, tp)
    end
    if chk == 0 then
        return true
    end --Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
    local op = Duel.SelectOption(tp, aux.Stringid(41375811, 1), aux.Stringid(74586817, 1))
    e:SetLabel(op)

    if op == 0 then
        --special summon
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectTarget(tp, c420000042.filter, tp, LOCATION_REMOVED, LOCATION_REMOVED, 1, 1, nil, e, tp)
        Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
    else
        --return to grave
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectTarget(tp, c420000042.filter2, tp, LOCATION_REMOVED, LOCATION_REMOVED, 1, 2, nil, e, tp)
        Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, g:GetCount(), 0, 0)
    end
end
function c420000042.spop(e, tp, eg, ep, ev, re, r, rp)
    if e:GetLabel() == 0 then
        --special summon
        local tc = Duel.GetFirstTarget()
        if tc and tc:IsRelateToEffect(e) then
            Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
        end
    else
        --return to grave
        local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
        Duel.SendtoGrave(g, REASON_EFFECT + REASON_RETURN)
    end
end

function c420000042.synlimit(e, c)
    if not c then
        return false
    end
    return not (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end
