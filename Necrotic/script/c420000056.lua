--Dusker
function c420000056.initial_effect(c)
	--first ss
	c:EnableReviveLimit()
	--materials
	aux.AddFusionProcCodeFun(c,28297833,c420000056.ffilter,1,true,true)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c420000056.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c420000056.sprcon)
	e2:SetOperation(c420000056.sprop)
	e2:SetCountLimit(1, 420000056)
	c:RegisterEffect(e2)
	
	--attack
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(aux.Stringid(18940556,1))
	-- e4:SetCategory(CATEGORY_REMOVE)
	-- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	-- e4:SetCode(EVENT_BATTLE_START)
	-- e4:SetCost(c420000056.tgcost)
	-- e4:SetTarget(c420000056.tgtg)
	-- e4:SetOperation(c420000056.tgop)
	-- c:RegisterEffect(e4)
	
	--[[
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c420000056.destg)
	e4:SetValue(c420000056.value)
	e4:SetOperation(c420000056.desop)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	--]]
	
	--cannot target
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	-- e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetTargetRange(LOCATION_MZONE,0)
	-- e2:SetTarget(c420000056.tglimit)
	-- e2:SetValue(aux.tgoval)
	-- c:RegisterEffect(e2)
	
	--take control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17412721,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c420000056.spcon)
	e3:SetTarget(c420000056.cttg)
	e3:SetOperation(c420000056.ctop)
	c:RegisterEffect(e3)

	--protect
	--TODO
end
function c420000056.ffilter(c)
	return (c:IsType(TYPE_XYZ) or c:IsCode(93568288)) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end

function c420000056.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	
	local tc=e:GetHandler()
	if Duel.Remove(tc,tc:GetPosition(),REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetOperation(c420000056.retop)
		tc:RegisterEffect(e1)
	end
end
function c420000056.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end

function c420000056.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c420000056.tgop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.GetControl(d,tp,PHASE_END,1)
	end
end

function c420000056.spfilter1(c,tp)
	return c:IsCode(28297833) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
		and Duel.IsExistingMatchingCard(c420000056.spfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,c)
end
function c420000056.spfilter2(c)
	return c420000056.ffilter(c) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
end
function c420000056.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c420000056.spfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil,tp)
end
function c420000056.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c420000056.spfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c420000056.spfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		--if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c420000056.tglimit(e,c)
	return c~=e:GetHandler()
end

--[[
function c420000056.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c420000056.dfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c420000056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c420000056.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and Duel.IsExistingMatchingCard(c420000056.cfilter,tp,LOCATION_GRAVE,0,count*2,nil)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(420000056,1))
end
function c420000056.value(e,c)
	return c420000056.dfilter(c, e:GetHandlerPlayer())
end
function c420000056.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c420000056.cfilter,tp,LOCATION_GRAVE,0,count*2,count*2,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
--]]

function c420000056.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c420000056.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c420000056.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end








