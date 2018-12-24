--Medusa
function c420000059.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c420000059.lcheck)
	c:EnableReviveLimit()
	
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c420000059.regcon)
	e1:SetOperation(c420000059.regop)
	c:RegisterEffect(e1)

	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(420000059,0))
	-- e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c420000059.hspcon)
	e1:SetTarget(c420000059.hsptg)
	e1:SetOperation(c420000059.hspop)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(420000059,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	-- e2:SetCost(aux.bfgcost)
	e2:SetCost(c420000059.spcost)
	e2:SetTarget(c420000059.sptg)
	e2:SetOperation(c420000059.spop)
	c:RegisterEffect(e2)
end

function c420000059.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c420000059.hspfilter(c,e,tp)
	return c:IsCode(28297833) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) --and c:IsAbleToGrave()
end
function c420000059.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.IsExistingMatchingCard(c420000059.hspfilter,tp,LOCATION_DECK,0,1,nil) end
	-- Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c420000059.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c420000059.hspop(e,tp,eg,ep,ev,re,r,rp)
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- local g=Duel.SelectMatchingCard(tp,c420000059.hspfilter,tp,LOCATION_DECK,0,1,1,nil)
	-- if g:GetCount()>0 then
	-- 	Duel.SendtoGrave(g,REASON_EFFECT)
	-- end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c420000059.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
	end
	Duel.SpecialSummonComplete()
end

function c420000059.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c420000059.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c420000059.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c420000059.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(420000059) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function c420000059.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end

function c420000059.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c420000059.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c420000059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true--Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c420000059.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c420000059.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c420000059.spfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE) then
		local c = e:GetHandler()
		local fid = c:GetFieldID()
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		
		tc:RegisterFlagEffect(420000059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c420000059.rmcon)
		e1:SetOperation(c420000059.rmop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		Duel.SpecialSummonComplete()
	end
end
function c420000059.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(420000059)==e:GetLabel()
end
function c420000059.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end





























